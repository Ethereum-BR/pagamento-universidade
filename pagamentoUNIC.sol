pragma solidity ^0.4.18;

contract pagamentoUNIC {

  address public enderecoUNIC = 0x8977C1F513ca4C60d331B027911AFd23Aa370557;  // UNIC = University of Nicosia
  uint dataUltimaTransferencia;
  address proprietario;
  event UnicFoiPaga(address enderecoQueDisparouContrato, address destinatario, uint valor);
  event SaldoInsuficiente(address enderecoQueDisparouContrato, address destinatario, uint valorATransferir, uint saldo);
  event UltimaTransferenciaMenor30Dias(address enderecoQueDisparouContrato, address destinatario, uint dataUltimaTransferencia);  

  function pagamentoUNIC() public payable {
    proprietario = msg.sender;  
  }
  
  function transfereParaUNIC() public payable {
  	uint valorATransferir = 1 ether;

  	if(this.balance < valorATransferir) {
      		SaldoInsuficiente(msg.sender, enderecoUNIC, valorATransferir, this.balance);
      		return;
    	}

	// Se a ultima transferencia foi feita a menos de 30 dias, não permitir nova transferencia  	 
	if (now < dataUltimaTransferencia + 30 days) {
        	UltimaTransferenciaMenor30Dias(msg.sender, enderecoUNIC, dataUltimaTransferencia);
        	return;
    	}

   	enderecoUNIC.transfer(valorATransferir);  // Caso não consiga transferir, gera erro e não prossegue
   	
	dataUltimaTransferencia = now;	
	UnicFoiPaga(msg.sender, enderecoUNIC, valorATransferir);
  } 

  function autoDestruicao() public payable {
  	selfdestruct(proprietario);
  }

}
