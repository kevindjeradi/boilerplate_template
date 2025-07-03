import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boilerplate_template/features/connectivity/controllers/connectivity_controller.dart';
import 'package:boilerplate_template/shared/constants/responsive_sizes.dart';

class ConnectivityStatusCard extends StatelessWidget {
  const ConnectivityStatusCard({
    super.key,
    required this.connectivityState,
  });

  final AsyncValue<ConnectivityState> connectivityState;

  @override
  Widget build(BuildContext context) {
    return connectivityState.when(
      data: (state) => Card(
        child: Padding(
          padding: EdgeInsets.all(context.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: context.marginSmall,
            children: [
              const Text(
                'Connectivity Status:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                spacing: context.marginSmall,
                children: [
                  Icon(
                    state is ConnectivityConnected
                        ? Icons.wifi
                        : Icons.wifi_off,
                    color: state is ConnectivityConnected
                        ? Colors.green
                        : Colors.red,
                  ),
                  Text(
                    state is ConnectivityConnected
                        ? 'Connected (${state.connectionType.name})'
                        : state is ConnectivityDisconnected
                            ? 'Disconnected'
                            : 'Checking...',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      loading: () => Card(
        child: Padding(
          padding: EdgeInsets.all(context.paddingMedium),
          child: const Text('Loading connectivity...'),
        ),
      ),
      error: (error, _) => Card(
        child: Padding(
          padding: EdgeInsets.all(context.paddingMedium),
          child: Text('Connectivity error: $error'),
        ),
      ),
    );
  }
}
