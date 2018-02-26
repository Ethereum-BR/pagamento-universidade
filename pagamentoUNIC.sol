pragma solidity ^0.4.18;

contract pagamentoUNIC {

  address public enderecoUNIC; // UNIC = University of Nicosia
  address proprietario;  
  
  uint dataUltimaTransferencia;
  uint valorATransferir;
  
  address[] whiteList;
  
  event UnicFoiPaga(address enderecoQueDisparouContrato, address destinatario, uint valor);
  event SaldoInsuficiente(address enderecoQueDisparouContrato, address destinatario, uint valorATransferir, uint saldo);
  event UltimaTransferenciaMenor30Dias(address enderecoQueDisparouContrato, address destinatario, uint dataUltimaTransferencia);
  event NovoValor(uint valorAlterado);
  event ElementoWhiteList(uint indice, address elemento);
  event ElementoRemovido(address endereco);

  function pagamentoUNIC() public payable {
    proprietario = msg.sender;
    dataUltimaTransferencia = 0;
    valorATransferir = 1 ether;
    enderecoUNIC = 0x8977C1F513ca4C60d331B027911AFd23Aa370557;
  }

  function mudaEnderecoUNIC(address _novoEndereco) public somenteDono {
      enderecoUNIC = _novoEndereco;
   }

  modifier somenteDono() {
    require(msg.sender == proprietario);
    _;
  }

  function alteraValorATransferir(uint _novoValor) public somenteDono {
      valorATransferir = _novoValor;
      NovoValor(valorATransferir);
  }
  
  function adicionaEndereco(address _enderecoAAdicionar) public somenteDono {
      whiteList.push(_enderecoAAdicionar);
  }
  
  function removeEndereco(address _enderecoARemover) public {
    for (uint i = 0; i < whiteList.length-1; i++) {
            if(whiteList[i] == _enderecoARemover) {
              delete whiteList[i];
              ElementoRemovido(whiteList[i]);
            }
    }
  }

  function listaWhiteList() public {
    for (uint i = 0; i < whiteList.length-1; i++) {
            ElementoWhiteList(i+1, whiteList[i]);
    }
  }
  
  function transfereParaUNIC() public payable {
    // Se o contrato nao tiver saldo do valor da mensalidade, a função não fará nada
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
