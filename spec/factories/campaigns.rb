FactoryGirl.define do
  factory :campaign, class: Campaign do

    course = Random.rand(10000..30000)
    year = Random.rand(9..14)
    sequence(:name) {|n| "Campaign #{course}E #{year}"}
    comment { Faker::Lorem.sentence(Random.rand(0..2)).chomp('.') }

    inspNumber = Random.rand(2..10)
    after(:build) do |campaign|
      (1..inspNumber).each do |number|
        campaign.inspections << FactoryGirl.create(:inspection, name: "#{campaign.name} #{number}", campaign: campaign)
      end
    end

    factory :campaign_with_users do
      after(:build) do |campaign|
        campaign.inspections.each do |insp|
          author =  create(:user)
          author.add_role(:author, insp)
          moderator =  create(:user)
          moderator.add_role(:moderator, insp)
          inspector =  create(:user)
          inspector.add_role(:inspector, insp)
          insp.users << author
          insp.users << moderator
          insp.users << inspector
          (1..Random.rand(5..15)).each do
            insp.remarks << create(:remark, user: insp.users[Random.rand(1..2)])
          end
          (1..Random.rand(5..15)).each do
            insp.chat_messages << create(:ChatMessage, user: insp.users[Random.rand(0..2)])
          end
        end
      end
    end

  end
end