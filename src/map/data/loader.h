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
#include <optional>
#include <regex>
#include <string>
#include <string_view>
#include <vector>

namespace xi::data
{

inline auto zoneDataName(const xi::ZoneId zoneId, const std::string_view name) -> std::string
{
    return fmt::format("zones/{}/{}", EnumTraits<xi::ZoneId>::toName(zoneId), name);
}

inline auto zoneFilePath(const xi::ZoneId zoneId, const std::string_view name) -> std::string
{
    return fmt::format("data/{}.yaml", zoneDataName(zoneId, name));
}

// Unquotes numeric spawn keys created by the YAML emitter ('17657857': or "17657857": -> 17657857:)
inline auto fixNumericKeys(const std::string& text) -> std::string
{
    static const std::regex numericKeyRegex(R"(['"](\d+)['"]\s*:)");
    return std::regex_replace(text, numericKeyRegex, "$1:");
}

// Per-zone data file. No core file means the zone declares none of this kind.
template <class Dataset>
auto loadZoneFile(const xi::ZoneId zoneId) -> std::optional<typename Dataset::Records>
{
    const auto basePath = zoneFilePath(zoneId, Dataset::kDataPath);
    if (!std::filesystem::exists(basePath))
    {
        return std::nullopt;
    }

    const auto modules = getDataModulePaths(zoneDataName(zoneId, Dataset::kDataPath), ".yaml");

    try
    {
        // Deep merge active module overlays and sanitize numeric entity keys
        const auto mergedText = fixNumericKeys(loadMergedYaml(basePath, modules));
        auto records = Dataset::decode(mergedText);

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