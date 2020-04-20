require 'time'

module DataGenerator
  def self.current_time
    DateTime.now.new_offset(0).to_time.to_i
  end

  def self.random_time
    months = {
      2019 => (1..12).to_a,
      2020 => (1..3).to_a,
    }

    year = [2019, 2019, 2020, 2020, 2020].sample

    DateTime.new(
      year,
      months[year].sample,
      (1..28).to_a.sample,
      (0..23).to_a.sample,
      (0..59).to_a.sample,
      (0..59).to_a.sample,
    ).new_offset(0).to_time.to_i
  end

  def self.generate
    lenders = [
      "Derek Terry",
      "Estelle Blake",
      "Patrick Long",
      "Dixie Frazier",
      "Susie Drake",
      "Jerald Fernandez",
      "Robyn Sullivan",
      "Sherri Campbell",
      "Tricia Schultz",
      "Thelma Green",
      "Olivia Reyes",
      "Bernice Hardy",
      "Sidney Berry",
      "Jessie Rodriguez",
      "Terence Johnston",
      "Nathan Wood",
    ].map.with_index do |name, idx|
      Domain::User.new(
        id: idx,
        name: name,
        avatar_url: "../assets/avatar_#{idx}.jpg",
      )
    end

    states = [
      Domain::Loan::State::Draft,
      Domain::Loan::State::Draft,
      Domain::Loan::State::Draft,
      Domain::Loan::State::Draft,
      Domain::Loan::State::Submitted,
      Domain::Loan::State::Submitted,
      Domain::Loan::State::Submitted,
      Domain::Loan::State::Submitted,
      Domain::Loan::State::Approved,
      Domain::Loan::State::Approved,
      Domain::Loan::State::Approved,
      Domain::Loan::State::Rejected
    ]

    loans = {}

    [
      {
        street: "32 Melvin Way",
        city: "Seattle",
        state: "Washington",
        zip: "98175"
      },
      {
        street: "00384 Sachs Crossing",
        city: "Long Beach",
        state: "California",
        zip: "90840"
      },
      {
        street: "16 Erie Street",
        city: "Oklahoma City",
        state: "Oklahoma",
        zip: "73167"
      },
      {
        street: "7199 Clemons Road",
        city: "Charlotte",
        state: "North Carolina",
        zip: "28256"
      },
      {
        street: "38527 Anhalt Terrace",
        city: "Bowie",
        state: "Maryland",
        zip: "20719"
      },
      {
        street: "866 Magdeline Street",
        city: "West Palm Beach",
        state: "Florida",
        zip: "33405"
      },
      {
        street: "93208 Texas Pass",
        city: "Providence",
        state: "Rhode Island",
        zip: "02905"
      },
      {
        street: "354 Helena Plaza",
        city: "Cincinnati",
        state: "Ohio",
        zip: "45264"
      },
      {
        street: "22636 Lien Court",
        city: "Dallas",
        state: "Texas",
        zip: "75236"
      },
      {
        street: "2226 Spenser Junction",
        city: "Portland",
        state: "Oregon",
        zip: "97216"
      },
      {
        street: "3 Monica Circle",
        city: "Des Moines",
        state: "Iowa",
        zip: "50369"
      },
      {
        street: "6 Ruskin Center",
        city: "Houston",
        state: "Texas",
        zip: "77234"
      },
    ].each.with_index do |address, id|
      time = random_time

      loans[id] = Domain::Loan.new(
        id: id,
        notes: "",
        user: lenders.sample,
        address: Domain::Address.new(address),
        state: states.shift,
        created_at: time,
        updated_at: time,
      )
    end

    loans
  end
end
