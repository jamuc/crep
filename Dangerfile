not_declared_trivial = !github.pr_title.include?("trivial")

has_lib_changes = !git.modified_files.grep(/lib/).empty?
has_fixture_changes = !git.modified_files.grep(/spec/fixtures/).empty?
no_readme_changes = !git.modified_files.include?("Readme.md")

no_changelog_entry = !git.modified_files.include?("Changelog.md")

warn("PR is classed as Work in Progress") if github.pr_title.include? "WIP"
warn("Big PR") if git.lines_of_code > 500

if has_lib_changes && no_changelog_entry && not_declared_trivial
  warn("Any changes to library code should be reflected in the Changelog. Please consider adding a note there.")
end

if has_fixture_changes && no_readme_changes
  fail("Any changes in the fixtures should be reflected in the Readme's usage example.")
end
