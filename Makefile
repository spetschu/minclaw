TEST_VAULT := test_vault
BOOTSTRAP_SRC := BOOTSTRAP.md
ASSISTANT_SRC := ASSISTANT.md

.PHONY: help testprep testclean teststatus

help:
	@echo "Targets:"
	@echo "  make testprep   - clean generated assistant state and copy BOOTSTRAP.md + ASSISTANT.md into $(TEST_VAULT)/"
	@echo "  make testclean  - remove generated assistant files from $(TEST_VAULT)/"
	@echo "  make teststatus - show current bootstrap test vault state"

testclean:
	@rm -rf $(TEST_VAULT)/_assistant
	@rm -f $(TEST_VAULT)/BOOTSTRAP.md
	@rm -f $(TEST_VAULT)/BOOTSTRAP_DONE.md
	@rm -f $(TEST_VAULT)/ASSISTANT.md
	@echo "Cleaned generated assistant files from $(TEST_VAULT)/"

testprep: testclean
	@cp $(BOOTSTRAP_SRC) $(TEST_VAULT)/BOOTSTRAP.md
	@cp $(ASSISTANT_SRC) $(TEST_VAULT)/ASSISTANT.md
	@echo "Prepared $(TEST_VAULT)/ with current BOOTSTRAP.md and ASSISTANT.md"
	@echo "Next: cd $(TEST_VAULT) and launch your target CLI for manual bootstrap testing"

teststatus:
	@echo "Vault: $(TEST_VAULT)"
	@echo "Root assistant files:"
	@ls -1 $(TEST_VAULT)/BOOTSTRAP.md $(TEST_VAULT)/BOOTSTRAP_DONE.md $(TEST_VAULT)/ASSISTANT.md 2>/dev/null || true
	@echo ""
	@echo "_assistant directory:"
	@ls -la $(TEST_VAULT)/_assistant 2>/dev/null || echo "(not present)"
