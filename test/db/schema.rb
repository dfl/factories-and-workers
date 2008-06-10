ActiveRecord::Schema.define do

  create_table :monkeys do |t|
    t.column :name, :string
    # t.column :unique, :string
  end
  
  create_table :pirates do |t|
    t.column :catchphrase, :string
    t.column :monkey_id, :integer
    t.column :created_on, :datetime
    t.column :updated_on, :datetime
  end
  
end
