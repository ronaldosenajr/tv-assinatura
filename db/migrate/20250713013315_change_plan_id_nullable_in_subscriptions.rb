class ChangePlanIdNullableInSubscriptions < ActiveRecord::Migration[8.0]
  def change
    change_column_null :subscriptions, :plan_id, true
  end
end
