desc "Fill the database tables with some sample data"
task({ sample_data: :environment }) do
  puts "Creating sample data..."

  # ── Guard: skip if already seeded ────────────────────────────────────────
  if Trip.where(title: "Tokyo Adventure").exists?
    puts "Sample data already exists — skipping. (Delete the 'Tokyo Adventure' trip to re-seed.)"
    next
  end

  # ── Disable geocoding so we can supply lat/lng directly ──────────────────
  Activity.skip_callback(:validation, :after, :geocode)

  # ── Helper lambdas ────────────────────────────────────────────────────────
  make_trip = ->(title, owner) {
    trip = Trip.create!(title: title)
    Membership.create!(trip_id: trip.id, user_id: owner.id, role: "owner")
    trip
  }

  # ── Users ─────────────────────────────────────────────────────────────────
  puts "  Creating users..."

  alice = User.find_or_create_by!(email: "alice@example.com") do |u|
    u.username   = "alice_travels"
    u.first_name = "Alice"
    u.last_name  = "Chen"
    u.password   = "appdev123"
  end

  bob = User.find_or_create_by!(email: "bob@example.com") do |u|
    u.username   = "bob_explorer"
    u.first_name = "Bob"
    u.last_name  = "Martinez"
    u.password   = "appdev123"
  end

  carol = User.find_or_create_by!(email: "carol@example.com") do |u|
    u.username   = "carol_wanderer"
    u.first_name = "Carol"
    u.last_name  = "Kim"
    u.password   = "appdev123"
  end

  # ── Follows ───────────────────────────────────────────────────────────────
  puts "  Creating follows..."

  Follow.find_or_create_by!(follower_id: alice.id, followed_id: bob.id)
  Follow.find_or_create_by!(follower_id: alice.id, followed_id: carol.id)
  Follow.find_or_create_by!(follower_id: bob.id,   followed_id: alice.id)
  Follow.find_or_create_by!(follower_id: carol.id, followed_id: alice.id)
  Follow.find_or_create_by!(follower_id: carol.id, followed_id: bob.id)

  # ── ALICE: Tokyo Adventure ────────────────────────────────────────────────
  puts "  Creating Alice's trips..."

  tokyo = make_trip.("Tokyo Adventure", alice)

  tk1 = Day.create!(trip: tokyo, title: "Arrival & Shinjuku",  date: Date.new(2026, 3, 15))
  tk2 = Day.create!(trip: tokyo, title: "Asakusa & Akihabara", date: Date.new(2026, 3, 16))
  tk3 = Day.create!(trip: tokyo, title: "Harajuku & Shibuya",  date: Date.new(2026, 3, 17))

  sg = Activity.create!(day: tk1, name: "Shinjuku Gyoen National Garden",
    address: "Shinjuku Gyoen National Garden, Tokyo, Japan",
    notes: "Beautiful cherry blossoms — go early to beat the crowds. The French garden section is underrated.",
    picture_caption: "Spring in full bloom",
    latitude: 35.6851, longitude: 139.7100)

  rn = Activity.create!(day: tk1, name: "Ramen Nagi",
    address: "1 Chome-1 Kabukicho, Shinjuku, Tokyo, Japan",
    notes: "Best tonkotsu ramen I've ever had. Expect a 30-min queue — worth every minute.",
    latitude: 35.6938, longitude: 139.7031)

  sj = Activity.create!(day: tk2, name: "Senso-ji Temple",
    address: "2-3-1 Asakusa, Taito City, Tokyo, Japan",
    notes: "Over 1,400 years old and still breathtaking. The Nakamise shopping street leading up to it is great for souvenirs.",
    picture_caption: "Senso-ji at dawn",
    latitude: 35.7148, longitude: 139.7967)

  ak = Activity.create!(day: tk2, name: "Akihabara Electric Town",
    address: "Akihabara, Taito City, Tokyo, Japan",
    notes: "Tech paradise. Multi-floor arcades, anime shops, and every gadget imaginable.",
    latitude: 35.7022, longitude: 139.7741)

  ms = Activity.create!(day: tk3, name: "Meiji Shrine",
    address: "1-1 Yoyogikamizonocho, Shibuya City, Tokyo, Japan",
    notes: "A peaceful forested sanctuary a world away from the city. Arrive early for solitude.",
    picture_caption: "Torii gate at Meiji Shrine",
    latitude: 35.6764, longitude: 139.6993)

  sc = Activity.create!(day: tk3, name: "Shibuya Crossing",
    address: "2-2-1 Dogenzaka, Shibuya City, Tokyo, Japan",
    notes: "Go at rush hour for the full spectacle. Grab a window seat at the Starbucks above for a birds-eye view.",
    picture_caption: "Shibuya at night",
    latitude: 35.6590, longitude: 139.7006)

  # ── ALICE: Paris Getaway ──────────────────────────────────────────────────

  paris = make_trip.("Paris Getaway", alice)

  pr1 = Day.create!(trip: paris, title: "Eiffel Tower & The Louvre", date: Date.new(2026, 4, 10))
  pr2 = Day.create!(trip: paris, title: "Montmartre Morning",        date: Date.new(2026, 4, 11))

  et = Activity.create!(day: pr1, name: "Eiffel Tower",
    address: "Champ de Mars, 5 Avenue Anatole France, 75007 Paris, France",
    notes: "Magical at sunset. Book tickets online well in advance — queues without them are brutal.",
    picture_caption: "La Tour Eiffel at dusk",
    latitude: 48.8584, longitude: 2.2945)

  lv = Activity.create!(day: pr1, name: "Louvre Museum",
    address: "Rue de Rivoli, 75001 Paris, France",
    notes: "The Mona Lisa is smaller than expected. Don't miss the Winged Victory of Samothrace — stunning.",
    picture_caption: "The Louvre glass pyramid",
    latitude: 48.8606, longitude: 2.3376)

  sc2 = Activity.create!(day: pr2, name: "Sacré-Cœur Basilica",
    address: "35 Rue du Chevalier de la Barre, 75018 Paris, France",
    notes: "Stunning panoramic views over the city from the steps. Arrive early to get a quiet moment inside.",
    picture_caption: "View from Sacré-Cœur",
    latitude: 48.8867, longitude: 2.3431)

  # ── BOB: NYC Weekend ──────────────────────────────────────────────────────
  puts "  Creating Bob's trips..."

  nyc = make_trip.("NYC Weekend", bob)

  ny1 = Day.create!(trip: nyc, title: "Manhattan Highlights", date: Date.new(2026, 2, 20))
  ny2 = Day.create!(trip: nyc, title: "Brooklyn Bridge Day",  date: Date.new(2026, 2, 21))

  cp = Activity.create!(day: ny1, name: "Central Park",
    address: "Central Park, New York, NY 10024",
    notes: "Great morning run. Strawberry Fields is peaceful and Bethesda Fountain is iconic.",
    picture_caption: "Central Park in winter",
    latitude: 40.7829, longitude: -73.9654)

  met = Activity.create!(day: ny1, name: "The Metropolitan Museum of Art",
    address: "1000 5th Ave, New York, NY 10028",
    notes: "World-class art. The rooftop bar has incredible Central Park views (open in summer).",
    picture_caption: "The Met's grand entrance",
    latitude: 40.7794, longitude: -73.9632)

  bb = Activity.create!(day: ny2, name: "Brooklyn Bridge Walk",
    address: "Brooklyn Bridge, New York, NY 10038",
    notes: "Walk across at sunrise — the best light and almost no crowds. About 30 mins end to end.",
    picture_caption: "Brooklyn Bridge at sunrise",
    latitude: 40.7061, longitude: -73.9969)

  dumbo = Activity.create!(day: ny2, name: "DUMBO",
    address: "DUMBO, Brooklyn, New York, NY 11201",
    notes: "Great coffee shops and the Manhattan Bridge perfectly frames the Empire State Building.",
    picture_caption: "DUMBO with Manhattan Bridge",
    latitude: 40.7032, longitude: -73.9889)

  # ── BOB: Chicago Deep Dish Tour ───────────────────────────────────────────

  chicago = make_trip.("Chicago Deep Dish Tour", bob)

  ch1 = Day.create!(trip: chicago, title: "Deep Dish & Architecture", date: Date.new(2026, 1, 15))

  lm = Activity.create!(day: ch1, name: "Lou Malnati's Pizzeria",
    address: "439 N Wells St, Chicago, IL 60654",
    notes: "Best deep dish in the city. Get the butter crust. Plan to stay a while.",
    picture_caption: "The legendary deep dish",
    latitude: 41.8915, longitude: -87.6348)

  rw = Activity.create!(day: ch1, name: "Chicago Architecture Riverwalk",
    address: "Chicago Riverwalk, Chicago, IL 60601",
    notes: "The architecture boat tour from here is one of the best tours in any city. Book the Chicago Architecture Center tour.",
    picture_caption: "Chicago skyline from the river",
    latitude: 41.8872, longitude: -87.6261)

  # ── CAROL: Bali Retreat ───────────────────────────────────────────────────
  puts "  Creating Carol's trips..."

  bali = make_trip.("Bali Retreat", carol)

  ba1 = Day.create!(trip: bali, title: "Ubud Temples",          date: Date.new(2026, 3, 1))
  ba2 = Day.create!(trip: bali, title: "Seminyak Beach Day",    date: Date.new(2026, 3, 2))
  ba3 = Day.create!(trip: bali, title: "Sacred Monkey Forest",  date: Date.new(2026, 3, 3))

  tl = Activity.create!(day: ba1, name: "Tanah Lot Temple",
    address: "Beraban, Kediri, Tabanan Regency, Bali 82121, Indonesia",
    notes: "Best viewed at sunset. Arrive 2 hrs before sunset to explore without the rush.",
    picture_caption: "Tanah Lot at dusk",
    latitude: -8.6218, longitude: 115.0868)

  tr = Activity.create!(day: ba1, name: "Tegallalang Rice Terraces",
    address: "Tegallalang, Gianyar, Bali 80517, Indonesia",
    notes: "Go early morning for the best light and cooler temperatures. Entrance is free but guides will approach you.",
    latitude: -8.4335, longitude: 115.2783)

  sb = Activity.create!(day: ba2, name: "Seminyak Beach",
    address: "Seminyak Beach, Seminyak, Kuta, Badung Regency, Bali",
    notes: "Perfect for sunset. Grab a sun lounger mid-afternoon and stay for cocktails.",
    picture_caption: "Golden hour in Bali",
    latitude: -8.6888, longitude: 115.1588)

  mf = Activity.create!(day: ba3, name: "Sacred Monkey Forest Sanctuary",
    address: "Jl. Monkey Forest, Ubud, Gianyar, Bali 80571, Indonesia",
    notes: "Do NOT bring food — the monkeys will find it and they are not shy. Amazing ancient temple inside.",
    latitude: -8.5189, longitude: 115.2636)

  spa = Activity.create!(day: ba3, name: "Alaya Resort Ubud Spa",
    address: "Jl. Hanoman 75 Padangtegal, Ubud, Bali 80571, Indonesia",
    notes: "Treat yourself to a 90-min Balinese massage after the monkey forest. Completely restorative.",
    latitude: -8.5195, longitude: 115.2632)

  # ── Likes ─────────────────────────────────────────────────────────────────
  puts "  Creating likes..."

  # Bob likes Alice's activities
  [sg, sj, ms, sc, et, lv, sc2].each do |act|
    Like.find_or_create_by!(user_id: bob.id, activity_id: act.id)
  end

  # Alice likes Bob's activities
  [cp, bb, lm, rw].each do |act|
    Like.find_or_create_by!(user_id: alice.id, activity_id: act.id)
  end

  # Alice and Bob both like Carol's Bali activities
  [tl, sb, mf].each do |act|
    Like.find_or_create_by!(user_id: alice.id, activity_id: act.id)
    Like.find_or_create_by!(user_id: bob.id,   activity_id: act.id)
  end

  # ── Comments ──────────────────────────────────────────────────────────────
  puts "  Creating comments..."

  Comment.find_or_create_by!(user_id: bob.id,   activity_id: sg.id)  { |c| c.body = "The cherry blossoms look absolutely stunning! Adding this to my Japan list." }
  Comment.find_or_create_by!(user_id: carol.id, activity_id: sg.id)  { |c| c.body = "I went in autumn — the maple leaves were equally breathtaking." }
  Comment.find_or_create_by!(user_id: carol.id, activity_id: sj.id)  { |c| c.body = "Senso-ji at dawn must be magical. Did you catch the morning prayers?" }
  Comment.find_or_create_by!(user_id: carol.id, activity_id: et.id)  { |c| c.body = "Paris at sunset is unbeatable. Did you go up to the top level?" }
  Comment.find_or_create_by!(user_id: bob.id,   activity_id: et.id)  { |c| c.body = "Book tickets months ahead — so worth avoiding the queue!" }
  Comment.find_or_create_by!(user_id: alice.id, activity_id: cp.id)  { |c| c.body = "Miss NYC! Was this during marathon weekend? The park is electric then." }
  Comment.find_or_create_by!(user_id: carol.id, activity_id: bb.id)  { |c| c.body = "The sunrise walk across is on my bucket list. How long did it take?" }
  Comment.find_or_create_by!(user_id: alice.id, activity_id: tl.id)  { |c| c.body = "Bali is calling my name. Did you rent a scooter to get around?" }
  Comment.find_or_create_by!(user_id: bob.id,   activity_id: sb.id)  { |c| c.body = "That sunset looks unreal. Which beach club did you end up at?" }
  Comment.find_or_create_by!(user_id: alice.id, activity_id: mf.id)  { |c| c.body = "Haha the no-food warning is so real. A monkey stole my sunglasses there!" }

  # ── Journals (for Alice) ──────────────────────────────────────────────────
  puts "  Creating journal entries..."

  Journal.find_or_create_by!(user_id: alice.id, day_id: tk1.id) do |j|
    j.ai_generated_questions = "What was the most unexpected thing you discovered about Tokyo today?|How did the contrast between serene Shinjuku Gyoen and the electric energy of the city streets affect your mood?|Which moment today made you feel most like a local?"
    j.response = "The sheer scale of Shinjuku Gyoen took my breath away — thousands of people yet somehow completely peaceful. The ramen queue was 30 minutes but every second was worth it. What surprised me most is how quiet everyone is on the trains — the city is enormous but remarkably composed."
    j.best_activity_id = sg.id
  end

  Journal.find_or_create_by!(user_id: alice.id, day_id: tk2.id) do |j|
    j.ai_generated_questions = "Senso-ji has stood for over 1,400 years — what did that sense of deep history feel like standing there?|How did Akihabara's sensory overload compare to the temple's tranquility earlier in the day?|What would you do differently if you had this day again?"
    j.response = "Going from the incense and ancient timber of Senso-ji to the neon and noise of Akihabara in 30 minutes is quintessential Tokyo. The contrast is jarring but somehow makes both places feel richer. I wish I'd stayed another hour at the temple to watch it at dusk."
    j.best_activity_id = sj.id
  end

  Journal.find_or_create_by!(user_id: alice.id, day_id: pr1.id) do |j|
    j.ai_generated_questions = "The Eiffel Tower is one of the most photographed structures on Earth — did seeing it in person live up to years of expectation?|Which piece of art at the Louvre stopped you in your tracks and why?|Paris is called the City of Light — what lit you up today?"
    j.response = "The Eiffel Tower absolutely lived up to the hype. Watching it sparkle at night from the Trocadéro was magical in a way no photograph can capture. At the Louvre, it wasn't the Mona Lisa that got me — it was the Winged Victory of Samothrace. Headless, and still commanding the entire staircase."
    j.best_activity_id = et.id
  end

  Journal.find_or_create_by!(user_id: alice.id, day_id: ba1.id) do |j|
    j.ai_generated_questions = "Tanah Lot sits on a sea stack surrounded by water — how did the drama of its location make you feel?|The rice terraces have been farmed the same way for centuries. What did that continuity stir in you?|What smell, sound, or texture from today will you remember longest?"
    j.response = "Tanah Lot was worth every tour bus and every crowd. When the tide came in and the temple became an island, everything went quiet for a moment. The rice terraces were something else — cascading green as far as you could see, maintained by the same irrigation system for 1,000 years. Humbling."
    j.best_activity_id = tl.id
  end

  # ── Re-enable geocoding ───────────────────────────────────────────────────
  Activity.set_callback(:validation, :after, :geocode)

  puts ""
  puts "Done! Sample data created successfully."
  puts "  alice@example.com  / appdev123"
  puts "  bob@example.com    / appdev123"
  puts "  carol@example.com  / appdev123"
  puts ""
  puts "  Note: Cover images and activity photos cannot be seeded automatically."
  puts "  Upload images manually from each trip/activity page."
end
