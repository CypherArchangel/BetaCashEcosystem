# BetaCashEcosystem (English)

Dear Community,

This is the repository for the BetaCash Ecosystem. Initially, there will only be one token called "BetaCash," whose features I will explain in the "What is BetaCash?" subsection of this document. We will later add new contracts to the ecosystem, addressing different areas of the project.

## What is BetaCash?

BetaCash is a token programmed using a collection of OpenZeppelin smart contracts under the ERC20 standard. Thus, it inherits the following basic features from these contracts:

* It can be used as a voting mechanism for the DAO called "Beta"
* It can host meta-transactions.

The base OpenZeppelin ERC20 contract was extensively modified to include the following features:

* **Fully Decentralized Issuance and Redemption**: The smart contract itself acts as an Automated Market Maker (AMM). If a community member decides to buy BetaCash from the smart contract, they must deposit as much ETH as the tokens they require. This way, the token's price is always 1:1 with ETH.
  
  * This makes it impossible to perform a rug pull with the token. There is no pre-issuance of the token, nor are there extraordinary allocations.
  * The token is fully collateralized in ETH.
    
* **Decentralized Payment Agent**: Each transaction generates a 0.1% fee, which is divided as follows:
  
  * 0.02% goes to the programmer's address.
  * 0.02% goes to the DAO's address.
  * 0.06% is split equally into two distribution pools:
    
    * 0.03% goes to a "Pool A" distribution pool, from which the proportional part is distributed to those holding tokens worth more than 0.01% of the circulating tokens.
    * 0.03% goes to a "Pool B" distribution pool, from which 1% of the balance is distributed linearly among any address that has ever held tokens.

However, to avoid overloading and making the system expensive, each transaction executes 10 "Pool A" distributions and 10 "Pool B" distributions individually, with calculations based on the remaining pool balances in each specific distribution round.

## Why Use BetaCash?

BetaCash offers various incentives for using it, which are transparent and easy to understand:

* First, BetaCash always has a price equivalent to ETH. This is because each BetaCash is collateralized by an ETH in the smart contract. This means that if the price of BetaCash differs from the price of ETH in secondary markets, it creates an arbitrage opportunity for traders to profit by aligning the prices.
* Second, if you want to hold ETH for its potential future appreciation, it’s better to hold BetaCash because BetaCash will give you the upside of ETH plus commissions derived from arbitrage operations.
* Third, you generate a basic income in the form of passive earnings just by having had BetaCash in your address at some point.
* Fourth, you can participate in the DAO’s investment decisions to generate more income for BetaCash holders by investing the DAO's capital.

Therefore:

### INCENTIVE #1: Arbitrage between BetaCash and ETH.
### INCENTIVE #2: Earn the same as ETH plus commissions.
### INCENTIVE #3: Generate Basic Income, even if you don't have BetaCash in your wallet.
### INCENTIVE #4: Vote on important community decisions.

## How Will the BetaCash Ecosystem Improve?

The Ecosystem can improve in two ways:

* By promoting arbitrage operations, which will bring money into the DAO, and thus the DAO, controlled by holders, can make investments (or distribute the money as the majority wishes at any given time) to improve the ecosystem.
* By developing projects that generate income for BetaCash holders.

On this last point, I prefer not to comment further, as the system itself is good, transparent, and simple. There is no need to create hype for the project to work. Projects that integrate in the future or are already integrating are welcome.

## Whitelisting in BetaCash

There are vital smart contracts for the proper development of BetaCash. These contracts are mainly those that form secondary markets. Many of these AMMs do not support tokens with distributions. Therefore, the token has a whitelist where recipients in transfers generate the fee as a reverse charge. This way, the token is compatible with all AMMs. The whitelist is declared by the DAO, only for addresses associated with smart contracts and up to 50 addresses.

## Who is Behind BetaCash?

Behind BetaCash is me, Cypher Arcangel. No one else. There is no need to know more about me. Just read the smart contract.

# DON’T TRUST, VERIFY!

---------------------------------------------------

# BetaCashEcosystem (Español)

Estimada Comunidad,

Este es el repositorio del Ecosistema BetaCash. En un principio, solo habrá un token denominado "BetaCash" cuyas características expondré bajo la subsección "¿Qué es BetaCash"? de este archivo. Luego iremos agregando nuevos contratos al ecosistema, que tratarán diferentes areas del proyecto.

## ¿Qué es BetaCash?

BetaCash es un token programado sobre un compendio de contratos inteligentes de OpenZeppelin bajo el estándar ERC20. Así, hereda de estos contratos las siguientes características básicas:

* Puede ser utilizado como un mecanismo de voto para la DAO denominada "Beta".
* Puede albergar metatransacciones.

El Contrato ERC20 base de OpenZeppelin fue modificado ampliamente para albergar las siguientes características:

* **Emisión y Reembolso completamente descentralizado**: El propio contrato inteligente actúa como AMM. Si un miembro de la comunidad decide comprar BetaCash contra el contrato inteligente, deberá depositar tantos ETH como tokens requiera. Así el precio del token siempre es 1:1 con ETH.
  
  * De esta forma es imposible hacer un rug pull con el token. No hay pre-emisión del token, ni asignaciones extraordinarias.
  * El token está plenamente colateralizado en ETH.
    
* **Agente de Pagos descentralizado**: Cada transacción genera una comisión del 0.1%, que se divide de la siguiente forma,
  
  * 0.02% va dirigido a la dirección del programador.
  * 0.02% va dirigido a la dirección de la DAO.
  * 0.06% se concentra en dos pools de distribución a partes iguales:
    
    * 0.03% va a un pool de distribución "A" desde el cual se reparte la parte alícuota al saldo de aquellos que tengan tokens holdeados por valor superior al 0.01% de los tokens circulantes.
    * 0.03% va a un pool de distribución "B" desde el cual se reparte de forma lineal el 1% del saldo entre cualquier dirección que haya tenido tokens alguna vez.

Es importante entender no obstante que, para no saturar y encarecer el sistema, cada transacción ejecuta 10 transacciones de distribución "A" y 10 de distribución "B" y que cada transacción se realiza de forma individual, con lo que los cálculos se hacen sobre el saldo sobrante de los pools en cada ronda de distribución en particular.

## ¿Porqué utilizar BetaCash?

BetaCash te da diferentes incentivos para que lo utilices y son transparentes y sencillos de entender:

* Primero, BetaCash tiene un precio equivalente, en todo momento, a ETH. Esto es porque cada BetaCash tiene un ETH como colateral en el contrato inteligente. Esto significa que si el precio de BetaCash difiere del precio de ETH en los mercados secundarios, se da una oportunidad de arbitraje que los traders pueden utilizar para generar beneficios sincerando precios.
* Segundo, si quieres hodlear ETH por su posible apreciación futura, mejor hodlear BetaCash, simplemente porque BetaCash te va a dar el upside de ETH + comisiones derivadas de las operaciones de arbitraje.
* Tercero, generas una renta básica en forma de rendimientos pasivos solo para haber tenido BetaCash en algún momento en tu dirección.
* Cuarto, puedes participar en la toma de decisiones de inversión de la DAO, para generar más ingresos a los hodlers de BetaCash, invirtiendo con el capital de la DAO.

Por tanto:

### INCENTIVO Nº 1: Arbitraje entre BetaCash y ETH.
### INCENTIVO Nº 2: Genera lo mismo que ETH + comisiones.
### INCENTIVO Nº 3: Generas Renta Básica, así no tengas BetaCash en tu wallet.
### INCENTIVO Nº 4: Puedes votar en decisiones importantes para la comunidad.

## ¿Cómo se va a mejorar el Ecosistema de BetaCash?

El Ecosistema puede mejorar de dos formas:

* Mediante la promoción de las operaciones de arbitraje, que hará que ingrese dinero en la DAO y por tanto que la DAO, controlada por los hodlers, pueda hacer inversiones (o repartir el dinero como desee la mayoría en cada momento) para mejorar el ecosistema.
* Mediante proyectos que generen rentas para los hodlers de BetaCash.

En este último punto, prefiero no comentar nada más, ya que de por si el sistema es bueno, transparente y sencillo. No hace falta crear hype para que el proyecto funcione. Los proyectos que se integren en el futuro o que ya estén integrándose, bienvenido sean ;).

## Whitelisting en BetaCash

Existen contratos inteligentes vitales para el correcto desarrollo de BetaCash. Estos contratos son principalmente aquellos que conforman mercados secundarios. Muchos de estos AMM no tienen soporte para tokens con distribuciones. Es por ello que el token tiene un whitelist donde los destinatarios en las transferencias generan la comisión a cobro revertido. De esta forma el token es compatible con todos los AMM. El whitelist lo declara la DAO, solo para direcciones asociadas a contratos inteligentes y hasta un número de 50.

## ¿Quién está detrás de BetaCash?

Detrás de BetaCash estoy yo, Cypher Arcangel. Nadie más. No hace falta que conozcan más de mi. Solo lean el contrato inteligente.

# ¡NO CONFÍEN, VERIFIQUEN!


