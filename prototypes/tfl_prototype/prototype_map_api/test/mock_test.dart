import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:prototype_map_api/get_stations.dart';
import 'mock_test.mocks.dart' as mock;
import 'package:flutter_test/flutter_test.dart';

@GenerateMocks([http.Client])
void main() {
  group('getStations', () {
    test('Return iterable of stations', () async {
      final client = mock.MockClient();
      when(client.get(Uri.parse(
              'https://tfl.gov.uk/tfl/syndication/feeds/cycle-hire/livecyclehireupdates.xml')))
          .thenAnswer((_) async => http.Response(
              '<?xml version="1.0" encoding="utf-8"?>'
              '<stations lastUpdate="1647431882152" version="2.0"><station>'
              '<id>1</id>'
              '<name>River Street , Clerkenwell</name>'
              '<terminalName>001023</terminalName>'
              '<lat>51.52916347</lat>'
              '<long>-0.109970527</long>'
              '<installed>true</installed>'
              '<locked>false</locked>'
              '<installDate>1278947280000</installDate>'
              '<removalDate/>'
              '<temporary>false</temporary>'
              '<nbBikes>9</nbBikes>'
              '<nbEmptyDocks>10</nbEmptyDocks>'
              '<nbDocks>19</nbDocks>'
              '</station>'
              '<station>'
              '<id>2</id>'
              '<name>Phillimore Gardens, Kensington</name>'
              '<terminalName>001018</terminalName>'
              '<lat>51.49960695</lat>'
              '<long>-0.197574246</long>'
              '<installed>true</installed>'
              '<locked>false</locked>'
              '<installDate>1278585780000</installDate>'
              '<removalDate/>'
              '<temporary>false</temporary>'
              '<nbBikes>13</nbBikes>'
              '<nbEmptyDocks>24</nbEmptyDocks>'
              '<nbDocks>37</nbDocks>'
              '</station>'
              '</stations>',
              200));

      final answer = await getStations(client);
      expect(answer.first.emptyDocks, 10);

    });
  });
}
