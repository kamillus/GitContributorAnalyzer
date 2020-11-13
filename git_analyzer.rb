require 'pathname'

module GitCommitAnalysis
  class GitAnalyzer
    attr_reader :files_with_limited_contributions_by_others, :file_path_heatmap

    LIMITED_CONTRIBUTION_PERCENT = 15/100

    def initialize(mapper, author)
      @mapper = mapper
      @author = author

      @files_with_limited_contributions_by_others ||= {}
      @file_path_heatmap ||= {}
      @author_contributions ||= {}
    end

    def process
      process_files_with_limited_contributions_by_others
      process_file_path_heatmap
      process_author_contributions
      process_score

      self
    end

    private

    def process_files_with_limited_contributions_by_others
      problem_files = []
      (@mapper.author_file_map[@author] || []).each do |file|
        numerator = 1
        denominator = 1
        authors = @mapper.file_author_map[file]
        authors.keys.each do |author_key|
          author = authors[author_key]
          if author_key == @author
            numerator = author["diff_score"]
          else
            denominator += author["diff_score"]
          end
        end

        if numerator/denominator > 0.5
          problem_files << {"file" => file, "score" => numerator/denominator}
        end

      end

      @files_with_limited_contributions_by_others = problem_files

    end

    def process_author_contributions

    end

    def process_file_path_heatmap
      @mapper.author_file_map[@author][0..-1].each do |file|
        path = Pathname(file).each_filename.to_a
        path[0..-2].each_with_index do |_, index|
          path_key = path[0,index+1].join("/")
          binding.pry if path_key.nil?
          @file_path_heatmap[path_key] ||= 0
          @file_path_heatmap[path_key] += 1
        end
      end
    end

    def process_score

    end

    def process_author_code_spread

    end

  end
end