require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib fuselage]))
require 'diffy'
require 'ruby-debug'
require 'base64'

include Fuselage

access_token = "11d5295ea3814f9be2e52d966252cc461dab200b"

def compare(tree1, tree2, &block)
  tree1.each do |files1|
    tree2.each do |files2|
      if files2['path'] == files1['path']
        if files2['sha'] != files1['sha']
          yield files1['path'], files1['sha'], files2['sha']
        end
      end
    end
  end
end

def fastforward?(main, branch)
  
end

authenticated(access_token) do 
  
  repo = Repository.find('tester')
  
  develop_ref = Reference.find('tester', 'heads/develop')
  feature_ref = Reference.find('tester', 'heads/feature_tr')
  
  develop_commit = repo.most_recent_commit(develop_ref.sha)
  feature_commit = repo.most_recent_commit(feature_ref.sha)
  
  develop_tree = Tree.find_recursive('tester', develop_commit.tree['sha'])
  feature_tree = Tree.find_recursive('tester', feature_commit.tree['sha'])
  
  diff_blobs = []
  compare(develop_tree.tree, feature_tree.tree) do |path, old_sha, new_sha|
    old_blob = Blob.find('tester', old_sha)
    new_blob = Blob.find('tester', new_sha)
    diff = Diffy::Diff.new(Base64.decode64(old_blob.content), Base64.decode64(new_blob.content)).to_s(:html_simple)
    diff_blobs << {:name => path, :diff => diff}
  end
  
  puts diff_blobs
end