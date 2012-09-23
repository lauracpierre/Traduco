require 'logger'
require 'rubygems'
require 'git-ssh-wrapper'
require 'find'
require_dependency 'extensions/dir_extensions'
require_dependency 'loc_processors/processor_factory'

class Project < ActiveRecord::Base
    # Attributes.
    attr_accessible :name, :default_language_id, :project_type_id, :repository_address, :repository_ssh_key, :repository_type_id, :user_ids, :cloned
    attr_accessor :user_ids

    # Associations.
    belongs_to :default_language, :class_name => "Language"
    belongs_to :project_type, :class_name => "ProjectType"
    belongs_to :repository_type, :class_name => "RepositoryType"

    has_many :sources, :dependent => :destroy
    has_many :translations, :dependent => :destroy
    has_and_belongs_to_many :users

    # Validations.
	validates :name, :presence => true
    
    # Triggers.
    before_save :populate_users, :if => :users_changed?

    def repository_clone
        # Make sure that the directory exists.
        Dir.mkpath self.get_repository_path

        # Clone the repository.
        wrapper = GitSSHWrapper.new(:private_key => self.repository_ssh_key, :log_level => 'ERROR')
        logger.debug `env #{wrapper.cmd_prefix} git clone #{self.repository_address} #{self.get_repository_path}`
        
        # Update the project to indicate that it was cloned.
        self.cloned = true
    ensure
        wrapper.unlink if wrapper
    end

    def repository_pull
        # Make sure that our project was cloned a first time.
        if !self.cloned
            return
        end

        # Pull the repository.
        wrapper = GitSSHWrapper.new(:private_key => self.repository_ssh_key, :log_level => 'ERROR')
        logger.debug `cd #{self.get_repository_path} && env #{wrapper.cmd_prefix} git pull `
    ensure
        wrapper.unlink if wrapper
    end

    def repository_push

    end

    def repository_scan
        # Make sure that our project was cloned a first time.
        if !self.cloned
            return []
        end

        # Retrieve the Loc Processor for our Project Type.
        loc_processor = ProcessorFactory.get_processor self.project_type

        # Use the Loc Processor to find the Loc Files in the repository.
        file_list = loc_processor.find_files Find.find(self.get_repository_path), self.default_language.format
        file_list.map { |file_path| self.get_relative_path(file_path) }
    end

    def get_relative_path (path)
        path.slice! get_repository_path
        path
    end

    def get_repository_path
        File.join Rails.root, "repositories", self.id.to_s
    end
        
    def users_changed?
        self.user_ids && self.user_ids.size > 1
    end

    protected

    def populate_users
        self.user_ids.delete ""
        self.users = User.find self.user_ids
    end

end
