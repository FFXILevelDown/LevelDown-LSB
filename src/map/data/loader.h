/*
===========================================================================

  Copyright (c) 2026 LandSandBoat Dev Teams

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

===========================================================================
*/

#pragma once

#include "common/enum_traits.h"
#include "common/logging.h"
#include "data/enums/zone.h"
#include "data/yaml/merge.h"

#include <cstdlib>
#include <exception>
#include <filesystem>
#include <fmt/format.h>
#include <fstream>
#include <iterator>
#include <optional>
#include <regex>
#include <string>
#include <vector>

namespace xi::data
{

inline auto zoneFilePath(const xi::ZoneId zoneId, const std::string_view name) -> std::string
{
    return fmt::format("data/zones/{}/{}.yaml", EnumTraits<xi::ZoneId>::toName(zoneId), name);
}

inline auto readFileToString(const std::string& path) -> std::string
{
    std::ifstream input(path, std::ios::binary);
    return std::string{ std::istreambuf_iterator<char>(input), std::istreambuf_iterator<char>() };
}

// Scans active modules for matching zone dataset overlays
inline auto getZoneModulePaths(const std::string& relativePath) -> std::vector<std::string>
{
    std::vector<std::string> paths;
    if (std::filesystem::exists("modules"))
    {
        for (const auto& entry : std::filesystem::directory_iterator("modules"))
        {
            if (entry.is_directory())
            {
                auto modPath = (entry.path() / "data" / relativePath).string();
                if (std::filesystem::exists(modPath))
                {
                    paths.push_back(modPath);
                }
            }
        }
    }
    return paths;
}

// Unquotes numeric spawn keys created by the YAML emitter ('17657857': or "17657857": -> 17657857:)
inline auto fixNumericKeys(const std::string& text) -> std::string
{
    // Updated to catch both single and double quotes, and handle optional spacing
    static const std::regex numericKeyRegex(R"(['"](\d+)['"]\s*:)");
    return std::regex_replace(text, numericKeyRegex, "$1:");
}

// Per-zone data file loader with native deep YAML module merging.
template <class Dataset>
auto loadZoneFile(const xi::ZoneId zoneId) -> std::optional<typename Dataset::Records>
{
    const auto basePath = zoneFilePath(zoneId, Dataset::kDataPath);
    if (!std::filesystem::exists(basePath))
    {
        return std::nullopt;
    }

    try
    {
        const auto relativePath = fmt::format("zones/{}/{}.yaml", EnumTraits<xi::ZoneId>::toName(zoneId), Dataset::kDataPath);
        const auto modulePaths  = getZoneModulePaths(relativePath);

        std::string text;
        if (modulePaths.empty())
        {
            // Read raw file directly if no module overrides exist
            text = readFileToString(basePath);
        }
        else
        {
            // Deep merge module overlay and unquote numeric keys
            text = fixNumericKeys(loadMergedYaml(basePath, modulePaths));
        }

        auto records = Dataset::decode(text);
        if constexpr (requires { Dataset::verifyZone(records, zoneId); })
        {
            Dataset::verifyZone(records, zoneId);
        }

        return records;
    }
    catch (const std::exception& error)
    {
        ShowCriticalFmt("{} is not valid: {}", basePath, error.what());
        std::exit(-1);
    }
}

} // namespace xi::data