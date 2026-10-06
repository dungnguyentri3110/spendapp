import 'package:spendapp/data/models/music_model/music_model.dart';

class HomeState {
  final List<MusicModel>? listMusic;

  const HomeState({this.listMusic});

  factory HomeState.init() {
    return HomeState(listMusic: []);
  }

  HomeState copy({List<MusicModel>? listMusic}) {
    return HomeState(listMusic: listMusic ?? this.listMusic);
  }
}
