public interface HandlesConditions extends HandlesMissingData{
	ConditionEnsemble getCondition();
	ConditionEnsemble getCondition(int idx);
	
	ConditionEnsemble getConditionCopy();
	ConditionEnsemble getConditionCopy(int idx);
}