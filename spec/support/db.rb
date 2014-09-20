ActiveRecord::Base.establish_connection(
  adapter: "sqlite3", database: ":memory:"
)

class Schema < ActiveRecord::Migration

  def change
    create_table :projects do |t|
      t.string :name
    end

    create_table :tickets do |t|
      t.belongs_to :project
      t.string :name
      t.string :state
      t.text :message
      t.datetime :created_at
      t.datetime :updated_at
      t.boolean :resolved
      t.integer :position
      t.float :rating
    end
  end
end

silence_stream(STDOUT) do
  Schema.new.change
end

class Project < ActiveRecord::Base
  has_many :tickets
end

class Ticket < ActiveRecord::Base
  belongs_to :project
end
