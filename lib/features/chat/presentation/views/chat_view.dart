import 'package:climate/features/chat/presentation/view_model/state/chat_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_model/cubit/chat_cubit.dart';
import 'widgets/message_bubble.dart';
import 'widgets/typing_indicator_widget.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/empty_chat_widget.dart';
import 'widgets/error_banner_widget.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    return BlocConsumer<ChatCubit, ChatStates>(
      listener: (context, state) {
        // Auto-scroll whenever messages change
        if (state is ChatLoading || state is ChatSuccess) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        final cubit = context.read<ChatCubit>();
        final isLoading = state is ChatLoading;

        // Determine the messages list from state
        final messages = switch (state) {
          ChatLoading(messages: final m) => m,
          ChatSuccess(messages: final m) => m,
          ChatError(messages: final m) => m,
          _ => <dynamic>[],
        };

        final errorMessage = state is ChatError ? (state).errorMessage : null;

        return Scaffold(
          backgroundColor: const Color(0xFFEFF6FF),
          appBar: _buildAppBar(
            context,
            isDark,
            scheme,
            cubit,
            messages.isEmpty,
          ),
          body: Column(
            children: [
              // ── Message List ─────────────────────────────────
              Expanded(
                child: messages.isEmpty && state is! ChatLoading
                    ? const EmptyChatWidget()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        itemCount: messages.length + (isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (isLoading && index == messages.length) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 60,
                                top: 4,
                                bottom: 4,
                              ),
                              child: const TypingIndicatorWidget(),
                            );
                          }
                          return MessageBubble(message: messages[index]);
                        },
                      ),
              ),

              // ── Error Banner ─────────────────────────────────
              if (errorMessage != null)
                ErrorBannerWidget(
                  message: errorMessage,
                  onDismiss: () => cubit.dismissError(),
                ),

              // ── Input Bar ────────────────────────────────────
              ChatInputBar(
                isLoading: isLoading,
                onSend: (text) => cubit.sendMessage(text),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    bool isDark,
    ColorScheme scheme,
    ChatCubit cubit,
    bool isEmpty,
  ) {
    return AppBar(
      titleSpacing: 16,
      title: Row(
        children: [
          // Bot Avatar
          // Container(
          //   width: 40,
          //   height: 40,
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       // بعد
          //       colors: [Color(0xFF2576F9), Color(0xFF6D98ED)],
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //     ),
          //     shape: BoxShape.circle,
          //   ),
          //   child: const Center(
          //     child: Text('🌤️', style: TextStyle(fontSize: 20)),
          //   ),
          // ),
          // const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Weather Bot',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                'AI-powered weather assistant',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Clear Chat
        if (!isEmpty)
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear chat',
            onPressed: () => _showClearDialog(context, cubit),
          ),
        // Dark Mode Toggle
      ],
    );
  }

  void _showClearDialog(BuildContext context, ChatCubit cubit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear Chat?'),
        content: const Text(
          'All messages will be deleted. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              cubit.clearChat();
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
