module Cockpit
  class Commit < Base

    attr_accessor :sha, :message, :parents, :author, :url, :tree, :committer

  end
end
