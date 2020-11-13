require 'git'
require 'pry'
require_relative 'git_mapper'
require_relative 'git_analyzer'

repo_url = ARGV[0]
author = ARGV[1]

TEMP_REPO_PATH = "/tmp/checkout"

if repo_url.nil? || author.nil?
  raise "Repo URL or Author email is empty"
end

puts "Cloning repo.. "
name = repo_url.split("/")[-1]
g = nil
begin
  g = Git.clone(repo_url, name, :path => TEMP_REPO_PATH)
rescue => e
  if e.message.include? "already exists and is not an empty directory"
    puts "Repo already exists.. continuing"
    g = Git.open(TEMP_REPO_PATH + "/#{name}")
  end
end

puts "Starting analysis.. "
mapper = GitCommitAnalysis::GitMapper.new(g, 500).analyze
analysis = GitCommitAnalysis::GitAnalyzer.new(mapper, author).process

puts
puts
puts "Files with relatively few contributions by others"
puts "================================================="
analysis.files_with_limited_contributions_by_others.sort_by {|v| -v["score"]}.each do |file|
  puts "#{file["file"]} => Score: #{file["score"]}"
end

puts
puts "Author contributions by path"
puts "================================================="
analysis.file_path_heatmap.select {|k, v| v > 1}.sort_by {|k, v| -v}.each do |item|
  puts "#{item[0]} => Commits: #{item[1]}"
end