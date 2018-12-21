package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"strconv"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	sc "github.com/hyperledger/fabric/protos/peer"
)

// Request an L/C by importer
func (t *LOCContract) requestLC(stub shim.ChaincodeStubInterface, args []string) sc.Response {
	var letterOfCreditBytes []byte
	var letterOfCredit *LetterOfCredit
	var err error

	if len(args) != 17 {
		err = errors.New(fmt.Sprintf("Incorrect number of arguments. Expecting 17, Found %d", len(args)))
		return shim.Error(err.Error())
	}

	lcID := args[0]
	amount, err := strconv.Atoi(args[1])
	proDesc := args[2]
	proWeight, err := strconv.ParseFloat(args[3], 64)
	proVol, err := strconv.ParseFloat(args[4], 64)
	issueDate := args[5]
	expiryDate := args[6]
	buyer := args[7]
	buyerAdd := args[8]
	buyerBank := args[9]
	seller := args[10]
	sellerAdd := args[11]
	sellerBank := args[12]
	shipFrom := args[13]
	shipTo := args[14]
	qunty, err := strconv.Atoi(args[15])
	PresentationDays, err := strconv.Atoi(args[16])

	letterOfCredit = &LetterOfCredit{LCId: lcID, Amount: amount, ProductDesc: proDesc, ProductWeight: proWeight,
		ProductVol: proVol, IssueDate: issueDate, ExpiryDate: expiryDate, Buyer: buyer,
		BuyerAddress: buyerAdd, BuyerBank: buyerBank, Seller: seller,
		SellerAddress: sellerAdd, SellerBank: sellerBank, ShipmentFrom: shipFrom, ShipmentTo: shipTo,
		Quantity: qunty, PresentationPeriodInDays: PresentationDays,
		 Status: REQUESTED}
	letterOfCreditBytes, err = json.Marshal(letterOfCredit)
	if err != nil {
		return shim.Error("Error marshaling letter of credit structure")
	}

	err = stub.PutState(lcID, letterOfCreditBytes)
	if err != nil {
		return shim.Error(err.Error())
	}
	fmt.Printf("Letter of Credit request for trade %s recorded\n", args[0])

	return shim.Success(nil)
}

// Issue an L/C by bank
// We don't need to check the trade status if the L/C request has already been recorded
func (t *LOCContract) issueLC(stub shim.ChaincodeStubInterface, args []string) sc.Response {
	var letterOfCreditBytes []byte
	var letterOfCredit *LetterOfCredit
	var err error

	letterOfCreditBytes, err = stub.GetState(args[0])
	if err != nil {
		return shim.Error(err.Error())
	}

	// Unmarshal the JSON
	err = json.Unmarshal(letterOfCreditBytes, &letterOfCredit)
	if err != nil {
		return shim.Error(err.Error())
	}

	if letterOfCredit.Status == ISSUED {
		fmt.Printf("L/C for trade %s already issued", args[0])
	} else if letterOfCredit.Status == ACCEPTED {
		fmt.Printf("L/C for trade %s already accepted", args[0])
	} else {
		letterOfCredit.ExpiryDate = args[1]
		letterOfCredit.IssueDate = args[2]
		letterOfCredit.Status = ISSUED
		letterOfCreditBytes, err = json.Marshal(letterOfCredit)
		if err != nil {
			return shim.Error("Error marshaling L/C structure")
		}
		// Write the state to the ledger
		err = stub.PutState(args[0], letterOfCreditBytes)
		if err != nil {
			return shim.Error(err.Error())
		}
	}
	fmt.Printf("L/C issuance for trade %s recorded\n", args[0])

	return shim.Success(nil)
}

// Accept an L/C by exporter
func (t *LOCContract) acceptLC(stub shim.ChaincodeStubInterface, args []string) sc.Response {
	
	var letterOfCreditBytes []byte
	var letterOfCredit *LetterOfCredit
	var err error

	letterOfCreditBytes, err = stub.GetState(args[0])
	if err != nil {
		return shim.Error(err.Error())
	}

	// Unmarshal the JSON
	err = json.Unmarshal(letterOfCreditBytes, &letterOfCredit)
	if err != nil {
		return shim.Error(err.Error())
	}

	if letterOfCredit.Status == ACCEPTED {
		fmt.Printf("L/C for trade %s already accepted", args[0])
	} else if letterOfCredit.Status == REQUESTED {
		fmt.Printf("L/C for trade %s has not been issued", args[0])
		return shim.Error("L/C not issued yet")
	} else {
		letterOfCredit.Status = ACCEPTED
		letterOfCreditBytes, err = json.Marshal(letterOfCredit)
		if err != nil {
			return shim.Error("Error marshaling L/C structure")
		}
		// Write the state to the ledger
		err = stub.PutState(args[0], letterOfCreditBytes)
		if err != nil {
			return shim.Error(err.Error())
		}
	}
	fmt.Printf("L/C acceptance for trade %s recorded\n", args[0])

	return shim.Success(nil)
}

func (s *LOCContract) write(stub shim.ChaincodeStubInterface, args []string) sc.Response {
	var key, value string
	var err error

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting only 2 arguments")
	}

	key = args[0]
	value = args[1]
	err = stub.PutState(key, []byte(value))
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

func (s *LOCContract) read(stub shim.ChaincodeStubInterface, args []string) sc.Response {
	var key string
	var err error
	var valueASbytes []byte
	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting only 1 arguments")
	}

	key = args[0]

	valueASbytes, err = stub.GetState(key)
	if len(valueASbytes) == 0 || err != nil {
		return shim.Error("can't get value for " + key)
	}
	return shim.Success(valueASbytes)
}

func (s *LOCContract) getLCHistory(stub shim.ChaincodeStubInterface, args []string) sc.Response {
	type AuditHistory struct {
		id    string
		value []byte
	}

	var fullHistory []AuditHistory
	var err error
	var key string
	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting only 1 arguments")
	}

	key = args[0]
	txnIterator, err := stub.GetHistoryForKey(key)

	if err != nil {
		shim.Error(err.Error())
	}

	defer txnIterator.Close()
	for txnIterator.HasNext() {
		historyData, err := txnIterator.Next()

		if err != nil {
			shim.Error(err.Error())
		}
		var tx AuditHistory
		tx.id = historyData.TxId
		if historyData.Value == nil {
			tx.value = historyData.Value
		}
		tx.value = historyData.Value
		fullHistory = append(fullHistory, tx)
	}

	result, err := json.Marshal(fullHistory)
	return shim.Success(result)
}
