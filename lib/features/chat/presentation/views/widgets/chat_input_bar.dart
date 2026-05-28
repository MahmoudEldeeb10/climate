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
      if (hasText != _hasText) setState(() => _hasText = hasText);
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
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 90,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: !widget.isLoading,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(),
              maxLines: 4,
              minLines: 1,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                hintText: widget.isLoading
                    ? 'WeatherBot is thinking...'
                    : 'Ask about the weather...',
                prefixIcon: const Icon(
                  Icons.wb_sunny_outlined,
                  color: Color(0xFF2576F9),
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
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
              shape: BoxShape.circle,
              boxShadow: _hasText && !widget.isLoading
                  ? [
                      BoxShadow(
                        color: const Color(0xFF2576F9).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _hasText && !widget.isLoading ? _send : null,
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: isDark ? Colors.white38 : Colors.black26,
                          ),
                        )
                      : Icon(
                          Icons.send_rounded,
                          size: 20,
                          color: _hasText
                              ? Colors.white
                              : (isDark ? Colors.white30 : Colors.black26),
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
