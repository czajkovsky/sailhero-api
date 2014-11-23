Port.create(
  name: 'Stranda',
  latitude: 54.043302,
  longitude: 21.738819,
  city: 'Gizycko',
  street: 'Wojska Polskiego 7',
  telephone: '+48 501 122 610',
  website: 'http://stranda.pl/',
  additional_info: 'Showers for 6 minutes',
  spots: 70,
  depth: 5.0,
  price_per_person: 10.0,
  price_power_connection: 10.0,
  price_wc: 0.0,
  price_shower: 12.0,
  price_washbasin: 2.0,
  price_dishes: 0.0,
  price_wifi: 0.0,
  price_washing_machine: 15.0,
  price_emptying_chemical_toilet: 0.0,
  price_parking: 0.0,
  has_power_connection: true,
  has_wc: true,
  has_shower: true,
  has_washbasin: true,
  has_dishes: true,
  has_wifi: true,
  has_parking: true,
  has_slip: false,
  has_washing_machine: true,
  has_fuel_station: false,
  has_emptying_chemical_toilet: true
) if Port.where(name: 'Stranda').first.nil?

Port.find_or_create_by(
  name: 'Sztynort',
  latitude: 54.130976,
  longitude: 21.682389,
  city: 'Wegorzewo',
  street: 'Sztynort 11',
  telephone: '+48 87 427 51 80',
  website: 'http://www.tiga-yacht.com.pl/',
  additional_info: 'Showers for 10 minutes, restaurant available',
  spots: 120,
  depth: 3.5,
  price_per_person: 15.0,
  price_power_connection: 0.0,
  price_wc: 0.0,
  price_shower: 15.0,
  price_washbasin: 0.0,
  price_dishes: 0.0,
  price_wifi: 0.0,
  price_washing_machine: 15.0,
  price_emptying_chemical_toilet: 0.0,
  price_parking: 0.0,
  has_power_connection: true,
  has_wc: true,
  has_shower: true,
  has_washbasin: true,
  has_dishes: true,
  has_wifi: true,
  has_parking: true,
  has_slip: false,
  has_washing_machine: true,
  has_fuel_station: true,
  has_emptying_chemical_toilet: true
) if Port.where(name: 'Sztynort').first.nil?

Port.find_or_create_by(
  name: 'AZS Wilkasy',
  latitude: 54.011890,
  longitude: 21.735685,
  city: 'Wilkasy',
  street: 'Niegocinska 5',
  telephone: '+48 87 428 0 700',
  website: 'http://www.azs-wilkasy.pl/',
  additional_info: 'Showers for 10 minutes, restaurant available',
  spots: 30,
  depth: 3.5,
  price_per_person: 0.0,
  price_power_connection: 10.0,
  price_wc: 0.0,
  price_shower: 12.0,
  price_washbasin: 0.0,
  price_dishes: 0.0,
  price_wifi: 0.0,
  price_washing_machine: 5.0,
  price_emptying_chemical_toilet: 5.0,
  price_parking: 10.0,
  has_power_connection: true,
  has_wc: true,
  has_shower: true,
  has_washbasin: true,
  has_dishes: true,
  has_wifi: true,
  has_parking: true,
  has_slip: false,
  has_washing_machine: true,
  has_fuel_station: true,
  has_emptying_chemical_toilet: true
) if Port.where(name: 'AZS Wilkasy').first.nil?
