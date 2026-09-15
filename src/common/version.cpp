#include "version.h"

const char* version::GetGitSha()
{
    return "4c17b78d3c-dirty";
}

const char* version::GetGitBranch()
{
    return "base";
}

const char* version::GetGitDate()
{
    return "Tue Aug 18 13:27:31 2026";
}

const char* version::GetGitCommitSubject()
{
    return "Merge branch 'base' of https://github.com/FFXILevelDown/LevelDown-LSB into base";
}

const char* version::GetVersionString()
{
    return "base (4c17b78d3c-dirty)";
}
