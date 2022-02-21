import 'package:flutter/cupertino.dart';
import './restaurant_provider.dart';

class Restaurants with ChangeNotifier {
  final List<Restaurant> _items = [
    Restaurant(
      id: 'R1',
      websiteLink: '',
      facebookLink: '',
      name: 'Baje Ko Sekuwa',
      description: 'this is baje ko sekuwa.',
      isAvailable: true,
      openTime: DateTime.now(),
      closeTime: DateTime.now(),
      logo:
          'https://scontent.fktm7-1.fna.fbcdn.net/v/t31.18172-8/18489501_335014606913556_492681280385372510_o.jpg?_nc_cat=100&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=6Jw9c-jdz9gAX-Orhpm&_nc_ht=scontent.fktm7-1.fna&oh=00_AT9dAhGGXzYvxpS8aL7jEaZuDFex03R1fc7Mjl3xYMF-yA&oe=623764CC',
    ),
    Restaurant(
      id: 'R2',
      websiteLink: '',
      facebookLink: '',
      name: 'Bota',
      description: 'this is bota momo.',
      isAvailable: true,
      openTime: DateTime.now(),
      closeTime: DateTime.now(),
      logo:
          'https://scontent.fktm7-1.fna.fbcdn.net/v/t1.6435-9/130266301_2461044014191208_7763504459457148571_n.jpg?_nc_cat=108&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=0L1FEdU3CQ4AX86oLXi&tn=W3ij454VVmjS0Fqn&_nc_ht=scontent.fktm7-1.fna&oh=00_AT8DihVlPrbmIvfPwnOhu4MrS6m3qLNhQEE7wIVV1Aey-A&oe=623A2361',
    ),
    Restaurant(
      id: 'R3',
      websiteLink: '',
      facebookLink: '',
      name: 'Syanko',
      description: 'this is syanko roll.',
      isAvailable: true,
      openTime: DateTime.now(),
      closeTime: DateTime.now(),
      logo:
          'https://scontent.fktm7-1.fna.fbcdn.net/v/t1.6435-9/131239182_102826345050167_411239815355091193_n.jpg?_nc_cat=100&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=__K6YYyKpO0AX8hRbq-&_nc_ht=scontent.fktm7-1.fna&oh=00_AT9N1AgAGdFim8oNnE10fWFEpnCRd2nqX6cBBsd30vJrRQ&oe=62376E28',
    ),
    Restaurant(
      id: 'R4',
      websiteLink: '',
      facebookLink: '',
      name: 'Dalle',
      description: 'this is dalle momo.',
      isAvailable: true,
      openTime: DateTime.now(),
      closeTime: DateTime.now(),
      logo:
          'https://scontent.fktm7-1.fna.fbcdn.net/v/t1.6435-9/59332246_2306137089408275_6346559528464547840_n.jpg?_nc_cat=109&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=z0D3dv-RimgAX-8vTA8&_nc_ht=scontent.fktm7-1.fna&oh=00_AT8Z-4B0gXi19I37Hba0UWwN5_4bdqC1Z2UBtg-Li2YYUw&oe=6239AA40',
    ),
  ];

  List<Restaurant> get items {
    return [..._items];
  }
}