/*
 * Trade Finance Letter of credit - Use case - Group 2
 */

package main

import (
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	sc "github.com/hyperledger/fabric/protos/peer"
)

// Define the Smart Contract structure
type LOCContract struct {
}

// Define the letter of credit
type LetterOfCredit struct {
	LCId                     string  `json:"lcId"`
	ProductDesc              string  `json:"prodDesc"`
	ProductWeight            float64 `json:"prodWeight"`
	ProductVol               float64 `json:"prodVol"`
	ExpiryDate               string  `json:"expiryDate"`
	IssueDate                string  `json:"issueDate"`
	Buyer                    string  `json:"buyer"`
	BuyerAddress             string  `json:"bAdd"`
	BuyerBank                string  `json:"bBank"`
	Seller                   string  `json:"seller"`
	SellerAddress            string  `json:"sAdd"`
	SellerBank               string  `json:"sBank"`
	ShipmentFrom             string  `json:"shipFrom"`
	ShipmentTo               string  `json:"shipTo"`
	Amount                   int     `json:"amount"`
	Quantity                 int     `json:"qnty"`
	PresentationPeriodInDays int     `json:"presentationInDays"`
	Status                   string  `json:"status"`
}

// State values
const (
	REQUESTED	= "REQUESTED"
	ISSUED		= "ISSUED"
	ACCEPTED	= "ACCEPTED"
)

func (s *LOCContract) Init(APIstub shim.ChaincodeStubInterface) sc.Response {
	return shim.Success(nil)
}

func (s *LOCContract) Invoke(APIstub shim.ChaincodeStubInterface) sc.Response {
	// Retrieve the requested Smart Contract function and arguments
	function, args := APIstub.GetFunctionAndParameters()
	// Route to the appropriate handler function to interact with the ledger appropriately
	if function == "write" {
		return s.write(APIstub, args)
	} else if function == "read" {
		return s.read(APIstub, args)
	} else if function == "requestLC" {
		return s.requestLC(APIstub, args)
	}else if function == "issueLC" {
		return s.issueLC(APIstub, args)	
	}else if function == "acceptLC" {
		return s.acceptLC(APIstub, args)		
	} else if function == "getLCHistory" {
		return s.getLCHistory(APIstub, args)
	}
	return shim.Error("Invalid Smart Contract function name.")
}

// The main function is only relevant in unit test mode. Only included here for completeness.
func main() {
	// Create a new Smart Contract
	err := shim.Start(new(LOCContract))
	if err != nil {
		fmt.Printf("Error creating new Smart Contract: %s", err)
	}
}
