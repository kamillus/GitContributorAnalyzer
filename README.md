What is the GitContributorAnalyzer?
===================================
The script analyses a repo of your choice and outputs various stats for a single contributor to help understand code coverage on a human level.

Why?
====
The script can help you answer questions such as:
- "Is developer X working on something that nobody else knows about?"
- "What areas of the code has Developer X worked on in the last year?"

Usage
=====
`bundle exec ruby analyze.rb https://github.com/kamillus/GitContributorAnalyzer developer@email.com`

Sample Output
=============

```
Cloning repo..
Repo already exists.. continuing

Files with relatively few contributions by others
=================================================
lib/polymorphic_integer_type/activerecord_4/belongs_to_polymorphic_association_extension.rb => Score: 6
lib/polymorphic_integer_type/activerecord_4/belongs_to_polymorphic_association_extension.rb => Score: 6
spec/support/namespaced_animal.rb => Score: 2
lib/polymorphic_integer_type/polymorphic_array_value_extension.rb => Score: 2
spec/support/namespaced_animal.rb => Score: 2
lib/polymorphic_integer_type/polymorphic_array_value_extension.rb => Score: 2
lib/polymorphic_integer_type/polymorphic_array_value_extension.rb => Score: 2
spec/support/namespaced_animal.rb => Score: 2

Author contributions by path
=================================================
spec => Commits: 37
lib => Commits: 27
spec/support => Commits: 26
lib/polymorphic_integer_type => Commits: 22
spec/support/migrations => Commits: 10
lib/polymorphic_integer_type/activerecord_4 => Commits: 2
```