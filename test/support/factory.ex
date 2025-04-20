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
end
