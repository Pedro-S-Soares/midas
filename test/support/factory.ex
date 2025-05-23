defmodule Midas.Factory do
  use ExMachina.Ecto, repo: Midas.Repo

  alias Faker

  def user_factory do
    %Midas.Accounts.User{
      email: Faker.Internet.email(),
      hashed_password: Faker.String.base64(15)
    }
  end

  def money_source_factory do
    %Midas.Finances.MoneySource{
      name: Faker.Commerce.product_name(),
      description: Faker.Lorem.sentence(),
      current_value: "100.00"
    }
  end

  def finance_factory do
    %Midas.Finances.Finance{
      title: Faker.Lorem.sentence(),
      description: Faker.Lorem.sentence(),
      amount: "100.00",
      money_source: insert(:money_source),
      user: insert(:user)
    }
  end
end
