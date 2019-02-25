# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Discuss.Repo.insert!(%Discuss.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will halt execution if something goes wrong.
 alias Discuss.Repo
alias Discuss.Topic



for x <- 0..13000 do 
  Repo.insert %Topic{
    title: Faker.Lorem.Shakespeare.Ru.as_you_like_it()
  }
  Repo.insert %Topic{
    title: Faker.Lorem.Shakespeare.En.as_you_like_it()
  }
end