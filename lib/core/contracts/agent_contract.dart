class AgentContract {
  AgentContract({
    required this.agentId,
    required this.agentType,
    required Set<String> observationScope,
    required Set<String> allowedActions,
    required Set<String> humanApprovalActions,
    required Set<String> escalationConditions,
    required Set<String> recordRequirements,
  })  : observationScope = Set.unmodifiable(observationScope),
        allowedActions = Set.unmodifiable(allowedActions),
        humanApprovalActions = Set.unmodifiable(humanApprovalActions),
        escalationConditions = Set.unmodifiable(escalationConditions),
        recordRequirements = Set.unmodifiable(recordRequirements);

  final String agentId;
  final String agentType;

  /// What this agent is explicitly allowed to observe.
  final Set<String> observationScope;

  /// Actions this agent may execute without human approval.
  final Set<String> allowedActions;

  /// Actions that always require human approval.
  final Set<String> humanApprovalActions;

  /// Conditions that force escalation instead of autonomous action.
  final Set<String> escalationConditions;

  /// Evidence/state that must be recorded after decisions or actions.
  final Set<String> recordRequirements;

  bool canObserve(String subject) {
    return observationScope.contains(subject);
  }

  bool requiresHumanApproval(String action) {
    return humanApprovalActions.contains(action);
  }

  bool canAct(String action) {
    return allowedActions.contains(action) &&
        !humanApprovalActions.contains(action);
  }

  bool mustEscalate(String condition) {
    return escalationConditions.contains(condition);
  }

  bool mustRecord(String requirement) {
    return recordRequirements.contains(requirement);
  }
}
