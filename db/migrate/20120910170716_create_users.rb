class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :password
      t.string :password_salt
      t.string :email
      t.boolean :is_site_admin

      t.timestamps
    end
    
	  # Creating the table to linnk the many-to-many relationship
	  create_table :translations_users, :id => false do |t|
	    t.references :translation, :user
	  end
	  # creating index for efficiency
	  add_index :translations_users, [:translation_id, :user_id]
		  
	  
	  # Creating the table to linnk the many-to-many relationship
	  create_table :languages_users, :id => false do |t|
	  	 t.references :language, :user
	  end

	  # creating index for efficiency
	  add_index :languages_users, [:language_id, :user_id]
	
	  # Creating the table to linnk the many-to-many relationship
	  create_table :projects_users, :id => false do |t|
	  	 t.references :project, :user
	  end
	  # creating index for efficiency
	  add_index :projects_users, [:project_id, :user_id]
  end
end
