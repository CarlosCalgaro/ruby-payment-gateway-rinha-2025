Sequel.migration do
  up do
    alter_table(:payments) do
      add_column :created_at, DateTime, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end

  down do
    alter_table(:payments) do
      drop_column :created_at
    end
  end
end