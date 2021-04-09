import 'package:aktiv_app_flutter/Views/defaults/event_preview_box.dart';
import 'package:flutter/widgets.dart';

class FavoritesProvider extends ChangeNotifier {
  List<EventPreviewBox> _previewBoxes = <EventPreviewBox>[];

  List<EventPreviewBox> get boxes => this._previewBoxes;

  void addFavorite(EventPreviewBox box) {
    /// Mit box.id noch mit BackEnd verbinden
    _previewBoxes.add(box);
    notifyListeners();
  }

  void removeFavorite(EventPreviewBox box) {
    /// Mit box.id noch mit BackEnd verbinden
    _previewBoxes.remove(box);
    notifyListeners();
  }
}