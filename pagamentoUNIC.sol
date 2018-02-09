pragma solidity ^0.4.18;

contract pagamentoUNIC {

  address public enderecoUNIC = 0x8977C1F513ca4C60d331B027911AFd23Aa370557;  // UNIC = University of Nicosia
  uint dataUltimaTransferencia;
  event UnicFoiPaga(address enderecoQueDisparouContrato, address destinatario, uint valor);

  function pagamentoUNIC() public payable {
  }
  
  function transfereParaUNIC() public payable {
  	address enderecoRemetente = msg.sender;
  	uint valorATransferir = 1 ether;

    	// Se o contrato nao tiver saldo de pelo menos 1 Ether, a função não fará nada
  	require(this.balance >= valorATransferir);

	// Se a ultima transferencia foi feita a menos de 30 dias, não permitir nova transferencia  	 
	require(now >= dataUltimaTransferencia + 30 days); 

   	enderecoUNIC.transfer(valorATransferir);  // Caso não consiga transferir, gera erro e não prossegue
   	
	dataUltimaTransferencia = now;	
	UnicFoiPaga(msg.sender, enderecoUNIC, valorATransferir);
  } 

  function autoDestruicao() public payable {
  	selfdestruct(msg.sender);
  }

}
