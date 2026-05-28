import 'package:flutter/material.dart';

class ChatInputBar extends StatefulWidget {
  final void Function(String) onSend;
  final bool isLoading;

  const ChatInputBar({
    super.key,
    required this.onSend,
    required this.isLoading,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;

      if (hasText != _hasText) {
        setState(() {
          _hasText = hasText;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    if (widget.isLoading || !_hasText) return;

    final text = _controller.text.trim();

    _controller.clear();

    widget.onSend(text);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                      : [Colors.white, const Color(0xFFF8FAFC)],
                ),
                border: Border.all(
                  color: _hasText
                      ? const Color(0xFF2576F9)
                      : (isDark ? Colors.white12 : Colors.black12),
                  width: 1.3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _hasText
                        ? const Color(0xFF2576F9).withOpacity(0.15)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                enabled: !widget.isLoading,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                maxLines: 4,
                minLines: 1,
                cursorColor: const Color(0xFF2576F9),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: widget.isLoading
                      ? 'WeatherBot is thinking...'
                      : 'Ask about weather, rain, wind...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.cloud_outlined,
                      size: 22,
                      color: _hasText
                          ? const Color(0xFF2576F9)
                          : (isDark ? Colors.white38 : Colors.black38),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 45),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          /// Send Button
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _hasText && !widget.isLoading
                  ? const LinearGradient(
                      colors: [Color(0xFF2576F9), Color(0xFF6D98ED)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: _hasText && !widget.isLoading
                  ? null
                  : (isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0)),
              boxShadow: _hasText && !widget.isLoading
                  ? [
                      BoxShadow(
                        color: const Color(0xFF2576F9).withOpacity(0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: _hasText && !widget.isLoading ? _send : null,
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: isDark ? Colors.white38 : Colors.black26,
                          ),
                        )
                      : Transform.rotate(
                          angle: -0.4,
                          child: Icon(
                            Icons.send_rounded,
                            size: 24,
                            color: _hasText
                                ? Colors.white
                                : (isDark ? Colors.white30 : Colors.black26),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class ChatInputBar extends StatefulWidget {
//   final void Function(String) onSend;
//   final bool isLoading;

//   const ChatInputBar({
//     super.key,
//     required this.onSend,
//     required this.isLoading,
//   });

//   @override
//   State<ChatInputBar> createState() => _ChatInputBarState();
// }

// class _ChatInputBarState extends State<ChatInputBar> {
//   final TextEditingController _controller = TextEditingController();
//   bool _hasText = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller.addListener(() {
//       final hasText = _controller.text.trim().isNotEmpty;
//       if (hasText != _hasText) setState(() => _hasText = hasText);
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _send() {
//     if (widget.isLoading || !_hasText) return;
//     final text = _controller.text.trim();
//     _controller.clear();
//     widget.onSend(text);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Container(
//       padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
//       decoration: BoxDecoration(
//         color: isDark ? const Color(0xFF1E293B) : Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 16,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _controller,
//               enabled: !widget.isLoading,
//               textInputAction: TextInputAction.send,
//               onSubmitted: (_) => _send(),
//               maxLines: 4,
//               minLines: 1,
//               style: TextStyle(
//                 fontSize: 15,
//                 color: isDark ? Colors.white : const Color(0xFF0F172A),
//               ),
//               decoration: InputDecoration(
//                 hintText: widget.isLoading
//                     ? 'WeatherBot is thinking...'
//                     : 'Ask about the weather...',
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               gradient: _hasText && !widget.isLoading
//                   ? const LinearGradient(
//                       colors: [Color(0xFF2576F9), Color(0xFF6D98ED)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     )
//                   : null,
//               color: _hasText && !widget.isLoading
//                   ? null
//                   : (isDark
//                         ? const Color(0xFF334155)
//                         : const Color(0xFFE2E8F0)),
//               shape: BoxShape.circle,
//               boxShadow: _hasText && !widget.isLoading
//                   ? [
//                       BoxShadow(
//                         color: const Color(0xFF2576F9).withOpacity(0.4),
//                         blurRadius: 12,
//                         offset: const Offset(0, 4),
//                       ),
//                     ]
//                   : null,
//             ),
//             child: Material(
//               color: Colors.transparent,
//               shape: const CircleBorder(),
//               child: InkWell(
//                 customBorder: const CircleBorder(),
//                 onTap: _hasText && !widget.isLoading ? _send : null,
//                 child: Center(
//                   child: widget.isLoading
//                       ? SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: isDark ? Colors.white38 : Colors.black26,
//                           ),
//                         )
//                       : Icon(
//                           Icons.send_rounded,
//                           size: 20,
//                           color: _hasText
//                               ? Colors.white
//                               : (isDark ? Colors.white30 : Colors.black26),
//                         ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
