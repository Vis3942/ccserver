# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
User.create!(email: 'viswa@plscentral.com', password: 'rgx*23yvewPQz^', password_confirmation: 'rgx*23yvewPQz^', role: "admin" ) if Rails.env.development?
Group.create!(account_qb_id: '1234506789', name: "CCTestDept") if Rails.env.development?
Group.create!(account_qb_id: '7293472923', name: "ARGTestDept") if Rails.env.development?
Location.create!(
	group_id: 1,
	shipto_qb_id: "492912301",
	shipto_qb_name: "TensaInc",
	shipto_qb_address_l1: "205 Webster Street",
	shipto_qb_address_l2: "",
	shipto_qb_city: "Bethelehem", 
	shipto_qb_state: "PA",
	shipto_qb_zip: "18015",
	shipto_qb_country: "USA",
	shipto_qb_contact: "Person1",
	shipto_qb_phone_number: "16015173640", 
    time_zone: "America/New_York"
) if Rails.env.development?

Location.create!(
    group_id: 2,
    shipto_qb_id: "853923940",
    shipto_qb_name: "PennInc",
    shipto_qb_address_l1: "3401 Gray's Ferry Ave",
    shipto_qb_address_l2: "B197, Ste 105",
    shipto_qb_city: "Philadelphia", 
    shipto_qb_state: "PA",
    shipto_qb_zip: "19146",
    shipto_qb_country: "USA",
    shipto_qb_contact: "Person2",
    shipto_qb_phone_number: "12153953261", 
    time_zone: "America/New_York"
) if Rails.env.development?

Device.create!(
    serial_number: "56578",
    imei_number: "013039003900060",
    location_id: 1,
    service_tag: "KIX0Y3",
    firmware_version: "1.0",
    device_ping_data: "",
    device_ping_at: "",
    pay_per_use: false,
    decommissioned: false,
    missing: false,
    from: "2020-09-09 06:01:51",
    to: nil
) if Rails.env.development?

Device.create!(
    serial_number: "1234",
    imei_number: "861536030196001",
    location_id: 1,
    service_tag: "ABC4x2",
    firmware_version: "1.0",
    device_ping_data: "",
    device_ping_at: "",
    pay_per_use: false,
    decommissioned: false,
    missing: false,
    from: "2020-09-09 06:01:46",
    to: nil
) if Rails.env.development?

Device.create!(
    serial_number: "97532",
    imei_number: "351746051147349",
    location_id: 2,
    service_tag: "QXU9C5",
    firmware_version: "1.0",
    device_ping_data: "",
    device_ping_at: "",
    pay_per_use: false,
    decommissioned: false,
    missing: false,
    from: "2020-09-09 06:01:56",
    to: nil
) if Rails.env.development?

Device.create!(
    serial_number: "37923",
    imei_number: "356772081538377",
    location_id: 2,
    service_tag: "JFS8N5",
    firmware_version: "1.0",
    device_ping_data: "",
    device_ping_at: "",
    pay_per_use: false,
    decommissioned: false,
    missing: false,
    from: "2020-09-09 06:02:01",
    to: nil
) if Rails.env.development?

Device.create!(
    serial_number: "22289",
    imei_number: "357805023984442",
    location_id: 2,
    service_tag: "PUE9X1",
    firmware_version: "1.0",
    device_ping_data: "",
    device_ping_at: "",
    pay_per_use: false,
    decommissioned: false,
    missing: false,
    from: "2020-09-09 06:01:56",
    to: nil
) if Rails.env.development?

Device.create!(
    serial_number: "22289",
    imei_number: "357805023984442",
    location_id: 1,
    service_tag: "PUE9X1",
    firmware_version: "1.0",
    device_ping_data: "",
    device_ping_at: "",
    pay_per_use: false,
    decommissioned: false,
    missing: false,
    from: "2020-01-09 12:01:56",
    to: "2020-09-09 06:01:55"
) if Rails.env.development?
