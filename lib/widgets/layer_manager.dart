import 'package:flutter/material.dart';
import '../models/layer_model.dart';

const Color kAccentColor = Color(0xFF1DB9A0);
const Color kDarkBg = Color(0xFF1E1E1E);

class LayerManagerWidget extends StatefulWidget {
  final List<Layer> layers;
  final String? activeLayerId;
  final Function(List<Layer>) onReorder;
  final Function(String id) onSelectLayer;
  final Function(Layer updatedLayer) onUpdateLayer;
  final Function(String id) onDeleteLayer;

  const LayerManagerWidget({
    Key? key,
    required this.layers,
    required this.activeLayerId,
    required this.onReorder,
    required this.onSelectLayer,
    required this.onUpdateLayer,
    required this.onDeleteLayer,
  }) : super(key: key);

  @override
  State<LayerManagerWidget> createState() => _LayerManagerWidgetState();
}

class _LayerManagerWidgetState extends State<LayerManagerWidget> {
  final List<BlendMode> _blendModes = [
    BlendMode.srcOver, BlendMode.multiply, BlendMode.screen,
    BlendMode.overlay, BlendMode.darken, BlendMode.lighten,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kDarkBg,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Layers", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text("${widget.layers.length} Active", style: TextStyle(color: Colors.grey[400])),
              ],
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              itemCount: widget.layers.length,
              onReorder: (oldIndex, newIndex) {
                if (oldIndex < newIndex) newIndex -= 1;
                final List<Layer> newLayers = List.from(widget.layers);
                final item = newLayers.removeAt(oldIndex);
                newLayers.insert(newIndex, item);
                widget.onReorder(newLayers);
              },
              itemBuilder: (context, index) {
                final layer = widget.layers[index];
                final isActive = layer.id == widget.activeLayerId;
                return Container(
                  key: ValueKey(layer.id),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive ? kAccentColor.withOpacity(0.1) : Colors.grey[850],
                    border: Border.all(color: isActive ? kAccentColor : Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    onTap: () => widget.onSelectLayer(layer.id),
                    title: Text(layer.name, style: TextStyle(color: isActive ? kAccentColor : Colors.white)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(layer.isVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                          onPressed: () => widget.onUpdateLayer(layer.copyWith(isVisible: !layer.isVisible)),
                        ),
                        ReorderableDragStartListener(index: index, child: const Icon(Icons.drag_indicator, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
