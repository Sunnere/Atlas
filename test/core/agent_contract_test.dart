import 'package:atlas/core/contracts/agent_contract.dart';
import 'package:test/test.dart';

void main() {
  group('AgentContract', () {
    late AgentContract contract;

    setUp(() {
      contract = AgentContract(
        agentId: 'outdoor-agent',
        agentType: 'Outdoor Operations',
        observationScope: {
          'booking',
          'payment',
          'electricity_usage',
          'water_usage',
        },
        allowedActions: {
          'record_usage',
          'create_service_ticket',
          'notify_partner',
        },
        humanApprovalActions: {
          'change_infrastructure',
          'move_money',
          'sign_contract',
        },
        escalationConditions: {
          'safety_critical_fault',
          'conflicting_evidence',
          'insufficient_evidence',
        },
        recordRequirements: {
          'observation',
          'evidence',
          'decision',
          'action',
        },
      );
    });

    test('defines the agent observation boundary', () {
      expect(contract.canObserve('booking'), isTrue);
      expect(contract.canObserve('electricity_usage'), isTrue);
      expect(contract.canObserve('private_bank_credentials'), isFalse);
    });

    test('allows only explicitly permitted autonomous actions', () {
      expect(contract.canAct('record_usage'), isTrue);
      expect(contract.canAct('notify_partner'), isTrue);
      expect(contract.canAct('sign_contract'), isFalse);
      expect(contract.canAct('unknown_action'), isFalse);
    });

    test('requires human approval for protected actions', () {
      expect(
        contract.requiresHumanApproval('change_infrastructure'),
        isTrue,
      );
      expect(
        contract.requiresHumanApproval('move_money'),
        isTrue,
      );
      expect(
        contract.requiresHumanApproval('record_usage'),
        isFalse,
      );
    });

    test('forces escalation for unsafe or uncertain conditions', () {
      expect(
        contract.mustEscalate('safety_critical_fault'),
        isTrue,
      );
      expect(
        contract.mustEscalate('insufficient_evidence'),
        isTrue,
      );
      expect(
        contract.mustEscalate('normal_operation'),
        isFalse,
      );
    });

    test('defines mandatory recording requirements', () {
      expect(contract.mustRecord('observation'), isTrue);
      expect(contract.mustRecord('evidence'), isTrue);
      expect(contract.mustRecord('decision'), isTrue);
      expect(contract.mustRecord('action'), isTrue);
      expect(contract.mustRecord('random_note'), isFalse);
    });

    test('protects contract boundaries from external mutation', () {
      final observations = <String>{'booking'};
      final actions = <String>{'record_usage'};

      final isolatedContract = AgentContract(
        agentId: 'test-agent',
        agentType: 'Test',
        observationScope: observations,
        allowedActions: actions,
        humanApprovalActions: const {},
        escalationConditions: const {},
        recordRequirements: const {},
      );

      observations.add('private_data');
      actions.add('move_money');

      expect(
        isolatedContract.canObserve('private_data'),
        isFalse,
      );
      expect(
        isolatedContract.canAct('move_money'),
        isFalse,
      );
    });
  });
}
