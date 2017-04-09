class CreateCurrencies < ActiveRecord::Migration[5.0]
  def up
    create_table :currencies, id: false do |t|
      t.integer :id
      t.string :name
      t.timestamps
    end

    ActiveRecord::Base.connection.execute("ALTER TABLE currencies ADD PRIMARY KEY (id)")
  end

  def down
    drop_table :currencies
  end
end
