require_relative 'git_mapper'
require 'git'
require 'pry'

describe GitCommitAnalysis::GitMapper do
  let!(:diff) do
    <<~DIFF
      Test
      Test
      Test
    DIFF
  end

  describe "#diff_score" do
    it "returns the correct score" do
      mapper = double(Git::Diff::DiffFile)
      expect(mapper).to receive(:patch).and_return(diff)
      score = GitCommitAnalysis::GitMapper.new(nil,nil).send(:diff_score, mapper)
      expect(score).to eq(3)
    end
  end

  describe "#analyze" do
    it "returns correct data" do
      g = double(Git::Base)
      commit1 = double(Git::Object::Commit)
      commit2 = double(Git::Object::Commit)

      diff_file1 = double(Git::Diff::DiffFile)
      allow(diff_file1).to receive(:path).and_return("test/test")
      diff_file2 = double(Git::Diff::DiffFile)
      allow(diff_file2).to receive(:path).and_return("test/test")

      author = Git::Author.new("test")
      author.email = "test@test.com"
      allow(commit1).to receive(:author).and_return(author)
      allow(commit2).to receive(:author).and_return(author)

      expect(g).to receive(:log).and_return([commit1, commit2])

      mapper = GitCommitAnalysis::GitMapper.new(g,nil)
      allow(mapper).to receive(:diff_score).and_return(3)
      allow(mapper).to receive(:get_insertions_and_deletions).and_return([3,4])
      allow(mapper).to receive(:do_diff).and_return([diff_file1, diff_file2])

      analysis = mapper.analyze
      expect(analysis.author_file_map).to eq({"test@test.com"=>["test/test", "test/test"]})
      expect(analysis.file_author_map).to eq({"test/test"=>{"test@test.com"=>{"commits"=>2, "diff_score"=>6}}})

    end
  end
end