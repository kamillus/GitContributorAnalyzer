module GitCommitAnalysis
  class GitMapper
    attr_reader :analyzed_commits, :analyzed_files, :file_author_map, :author_file_map, :author_stat_map

    def initialize(g, log_count)
      @analyzed_commits ||= 0
      @analyzed_files ||= 0
      @log_count = log_count
      @g = g
    end


    def analyze
      @file_author_map ||= {}
      @author_file_map ||= {}
      @author_stat_map ||= {}

      log = @g.log(@log_count)
      log.each_with_index do |commit, index|
        break if index+1 == log.count
        diff = log[index].gtree.diff log[index+1]

        @author_stat_map[commit.author.email] ||= {}
        @author_stat_map[commit.author.email]["insertions"] ||= 0
        @author_stat_map[commit.author.email]["deletions"] ||= 0
        @author_stat_map[commit.author.email]["insertions"] += diff.insertions
        @author_stat_map[commit.author.email]["deletions"] += diff.deletions

        (diff).each do |diff_file|
          @author_file_map[commit.author.email] ||= []
          @author_file_map[commit.author.email] << diff_file.path

          @file_author_map[diff_file.path] ||= {}
          @file_author_map[diff_file.path][commit.author.email] ||= {}
          @file_author_map[diff_file.path][commit.author.email]["commits"] ||= 0
          @file_author_map[diff_file.path][commit.author.email]["commits"] += 1

          @file_author_map[diff_file.path][commit.author.email]["diff_score"] ||= 0
          @file_author_map[diff_file.path][commit.author.email]["diff_score"] += diff_score(diff_file)
          #binding.pry if commit.author.email == "ted.yang@clio.com"

          @analyzed_files += 1
        end

        @analyzed_commits += 1
      end

      self
    end

    private

    def diff_score(diff_file)
      #super non-scientific way of scoring changes..
      diff_file.patch.split("\n").count
    end


  end
end