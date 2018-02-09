pragma solidity ^0.4.18;

contract pagamentoUNIC {

  address public enderecoUNIC = 0x06012c8cf97BEaD5deAe257070F9587f8E7A266d;  // UNIC = University of Nicosia
  uint dataUltimaTransferencia;
  event Enviado(address remetente, address destinatario, uint valor);

  function transfereParaUNIC() public payable {
  	address enderecoRemetente = msg.sender;
  	uint valorATransferir = 1 ether;

    // Se Paulo (msg.sender) nao tiver saldo de pelo menos 1 Ether, a função não fará nada
  	require(enderecoRemetente.balance >= valorATransferir);

	  // Se a ultima transferencia foi feita a menos de 30 dias, não permitir nova transferencia  	 
	  require(now >= dataUltimaTransferencia + 30 days); 

   	enderecoUNIC.transfer(valorATransferir);  // Caso não consiga transferir, gera erro e não prossegue
   	
	  dataUltimaTransferencia = now;	
	  Enviado(msg.sender, enderecoUNIC, valorATransferir);
  }
}
