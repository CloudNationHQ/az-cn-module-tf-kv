.PHONY: test

export USECASE

#test_extended:

test:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/$(USECASE) ./key_vault_test.go

#test_local:

