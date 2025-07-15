Sequel.migration do
  up do
    create_table(:payments) do
      primary_key :id
      String :gateway, null: false
      Decimal :amount, size: [10, 2], null: false
    end
  end

  down do
    drop_table(:payments)
  end
end