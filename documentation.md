---
layout: page
title: Lógica Proposicional
author: Alex Gil
---

<head>
	<script type="text/javascript" async src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML">
		MathJax.Hub.Config({tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}});
	</script>
</head>

## Contents
{:.no_toc}

* ToC
{:toc}

---
## Introdução

Este projeto visa proporcionar uma facilidade para os estudantes da disciplina de Matemática Discreta I e entusiastas da área de lógicas de predicados e lógica proposicional. 

É comum cometermos erros na construção de determinadas provas matemáticas, principalmente na hora de verificar se uma prova está certa ao final do exercício.

Neste material abordaremos a construção das provas formais, e a sua verificação através da ferramenta Coq Proof Assistant.

## Pré-requisitos

Para utilizar a ferramenta do Coq, é necessário sua instalação e configuração (é bem simples). As versões para plataformas Windows e Mac/OS podem ser encontradas neste [link](https://github.com/coq/coq/releases/tag/V8.8.1). 

Em plataformas Windows opte pelo arquivo de extensão EXE referente à arquitetura da sua máquina (x64/x86). Em plataformas Mac/OS, baixe o arquivo de extensão DMG e siga os passos da instalação.

Para plataformas Ubuntu/Debian ,a instalação da versão mais atualiazada pode ser feita via terminal, da forma:

``` bash
$ sudo apt-get install coq coqide
```

Para verificar se a versão mais atualizada está instalada, utilize:

``` bash
$ coqc -v
```

Caso opte pelo arquivo compactado de formato TAR.GZ, disponível na [página](https://github.com/coq/coq/releases/tag/V8.8.1), descompacte-o utilizando:
``` bash
$ tar -xvzf coa-8.8.1.tar.gz
```

E finalmente, caso queira obter a versão do repositório git e se tornar um contribuidor, execute o camando abaixo em uma pasta vazia do seu computador:

``` bash
git clone https://github.com/coq/coq.git
```

Desta forma, você consegue o código-fonte do CoqIDE para editar, testar e reportar bugs para a comunidade para torná-lo uma ferramenta melhor!

## Utilizando o CoqIDE

O básico para a criação de provas formais na ferramenta Coq é a declaração das variáveis que vão corresponder às proposições. 

Cada proposição é declarada como uma váriavel do tipo ```Prop```. Utiliza-se a palavra chave ```Variables``` para declarar as variáveis. 

Segue um exemplo da criação de três variáveis do tipo proposição:

```coq
	Variables A B C : Prop.
```

Outro aspecto importante para a criação das provas formais é a criação dos lemas.

Um lema, que é identificados pelas palavra chave ```Lemma```, possui quase sempre a mesma estrutura:

```coq
	Lemma <nome_do_lema> : <proposicoes>
	Proof.
		<corpo_da_funcao>
	Qed.
```

Onde 'nome_do_lema' corresponde a um nome dado para o lema, 'proposicoes' corresponde à estrutura das proposições que se deseja provar e o 'corpo_da_funcao' que é onde as regras de inferências serão aplicadas.

Veja o seguinte exemplo de prova formal:

$$P \land Q \land T$$

Esta estrutura de prova, no CoqIDE, corresponde ao seguinte trecho de código:

```coq
	Lemma lema1 : P /\ Q T
	Proof.
		<regras de inferencia para a resolucao da prova>
	Qed.
```

## Regras de Inferência para Conjunção: Introdução e Eliminação do $$\land$$

A regra da introdução da conjunção, simbolizada por {$$\land I$$}, diz que dada duas premissas verdadeiras, pode concluir-se a conjunção dessas premissas, dada por $$P \land Q $$ ou $$Q \land P$$. Escreve-se da forma:

$$\dfrac{P\:\:\:Q}{P \land Q} \tiny{\land I}$$

A regra da eliminação da conjunção, também conhecida por regra da simplificação, é simbolizada por {$$\land E$$}. A partir desta regra, pode-se concluir $$P\:\:\:Q$$ de $$P \land Q$$. Escreve-se da forma:

$$\dfrac{P \land Q}{P\:\:\:Q} \tiny{\land E}$$

Exemplo de aplicação:

$$P \land Q \land T$$

A premissa pode ser declarada no coqIDE como:

```coq
	Lemma premissa (H: P /\ Q /\ T) : P /\ Q /\ T.
	Proof.

	Qed.
```

Para provarmos a premissa acima, primeiro temos de "quebra-lá" em duas hipóteses. Para isso, podemos chamar a função ```elim_e H. ``` no coqIDE, onde H é a nossa hipótese passada como parâmetro na função de eliminação do $$\land$$. Então, a primeira parte da prova ficaria:

```coq
	Lemma premissa (H: P /\ Q /\ T) : P /\ Q /\ T.
	Proof.
		elim_e H.
	Qed.
```

O resultado "parcial" da prova, mostrado no console do coqIDE (canto superior direito) ficaria:

```coq
	1 subgoal
H : A /\ B /\ C
H0 : A
H1 : B /\ C
______________________________________(1/1)
A /\ B /\ C
```

Logo, agora existem duas hipóteses, oriundas da "quebra" da premissa original: a hipótese ```H0: A``` e a hipótese ```H1: B /\ C```.

Agora, partimos primeiro para a hipóstese ```H0: A```. Esta premissa pode ser provada utilizando a introdução do $$\land$$. O método na bilbioteca referente a esta técnica é o ```intro_e.```. Portanto, a prova parcial e seu resultado ficariam da forma:

```coq
	Lemma premissa (H: P /\ Q /\ T) : P /\ Q /\ T.
	Proof.
		elim_e H.
		intro_e.
	Qed.
```

```coq
	2 subgoals
H : A /\ B /\ C
H0 : A
H1 : B /\ C
______________________________________(1/2)
A
______________________________________(2/2)
B /\ C
```

Com a nova premissa, a regra de $$/small{id}$$ pode ser utilizada para provar $$A$$, ou seja, a variável ```H0``` pode agora ser provada para o valor final ```true```. 

```coq
	Lemma premissa (H: P /\ Q /\ T) : P /\ Q /\ T.
	Proof.
		elim_e H.
		intro_e.
		id_H0.
	Qed.
```

Tendo como sub-resultados:

```coq
	1 subgoal
H : A /\ B /\ C
H0 : A
H1 : B /\ C
______________________________________(1/1)
B /\ C
```

Como $$A$$ não precisa mais ser provado, partiremos para a expressão $$B \land C$$. A mesma sequência de comandos que foi usada n prova anterior pode ser usada agora também para provar $$B \land C$$, porém, agora utilizaremos a variável de hipótese```H1```. Ficaria da forma: 

```coq
	Lemma premissa (H: P /\ Q /\ T) : P /\ Q /\ T.
	Proof.
		elim_e H.
		intro_e.
		id_H0.
		elim_e H1.
		intro_e.
		id H1.
		id H3.
	Qed.
```

Perceba que quando utilizamos o comando ```elim_e H1```, duas novas variáveis de hipótese aparecem (H2 e H3), assim como no comando ```elim_e H.```. E como resultado, a mensagem de que a prova foi finalizada e todas as vari´aveis de hipótese foram tratadas:

```coq
	No more subgoals.
```

## Regras de inferência para implicação

A regra de eliminação da implicação, também conhecida como $$\textit{Modus Ponens}$$, consiste na resolução de implicações lógicas. Veremos como resolve-lás com o Coq, através de um exemplo. 

Suponha a seguinte proposição:

$$\dfrac{(A \implies B) \land (B \implies C)}{A \implies C} \tiny{\implies E}$$

O primeiro passo para "dividir" a conclusão da prova, é utilizar a introdução da implicação:

```coq
Lemma tri_teste(H: A -> B) (H1: B -> C) : A -> C.
Proof.
  intro_implicacao.
```

O resultado do uso da função de introdução da implicação na conclusão nos dá o seguinte resultado:

```coq
1 subgoal
H : A -> B
H1 : B -> C
H0 : A
______________________________________(1/1)
C

```

Logo, uma nova hipótese $$H0$$ contendo o valor $$A$$ é criada pelo Coq. O próximo passo é fazer uma prova "intermediária" para $$B$$ utilizando o comando ```assert``` da forma:

```coq
Lemma tri_teste(H: A -> B) (H1: B -> C) : A -> C.
Proof.
  intro_implicacao.
  assert B.
```

A partir da hipótese $$H$$ contendo o valor $$A \implies B$$ e da hipótese $$H0$$ contendo o valor $$A$$, podemos inferir que $$A \implies B$$ é verdade utilizando o comando ```elim_implicacao H H0```. Veja a sequência para o exemplo:

```coq
Lemma tri_teste(H: A -> B) (H1: B -> C) : A -> C.
Proof.
  intro_implicacao.
  assert B.
  elim_implicacao H H0.
```

```coq
H : A -> B
H1 : B -> C
H0 : A
H2 : B
______________________________________(1/2)
B
______________________________________(2/2)
C
```

Para provarmos $$B$$ a partir de $$B$$, utilizamos o comando ```id H2```.

```coq
Lemma tri_teste(H: A -> B) (H1: B -> C) : A -> C.
Proof.
  intro_implicacao.
  assert B.
  elim_implicacao H H0.
  id H2.
```

E o resultado:

```coq
1 subgoal
H : A -> B
H1 : B -> C
H0 : A
H2 : B
______________________________________(1/1)
C
```

Logo, com o novo conjunto de hipóteses adquirido, conseguimos provar $$C$$ com certa facilidade. Basta utilizar o mesmo comando utilizado anteriormente para eliminação da implicação. O exemplo fica da forma:

```coq
Lemma tri_teste(H: A -> B) (H1: B -> C) : A -> C.
Proof.
  intro_implicacao.
  assert B.
  elim_implicacao H H0.
  id H2.
  elim_implicacao H1 H2.
  id H3.
Admitted.
```

E o resultado:

```coq
	No more subgoals.
```

## Regras de inferência para a negação

As regras para negação equivalem a duas regras de substituições válidas na lógica formal:
	"se $$P$$ é verdadeira, então $$¬¬P$$ também é verdadeira", e
	"se $$¬¬P$$ é verdadeira, então $$P$$ também é verdadeira".

A introdução da negação apresenta a forma:

$$\dfrac{P}{¬¬P} \tiny{{¬I}}$$

E a eliminação da negação apresenta a forma:

$$\dfrac{¬¬P}{P} \tiny{{¬E}}$$

Faremos agora um exemplo utilizando os comandos ```elim_negacao``` e ```intro_negacao```, implementados no CoqIDE para provarmos algumas sentenças lógicas. Seja:

$$\dfrac{¬A \implies A}{¬A \implies A \implies False}$$

Dentro do CoqIDE, a proposição seria da forma:

```coq
Lemma quar_teste(H: ~A -> A) : ~A -> A -> False.
Proof.
  
Admitted.
```

O primeiro passo para provarmos o exemplo acima é utilizar a introdução da implicação para "separarmos" a conclusão em novas hipóteses.

```coq
Lemma quar_teste(H: ~A -> A) : ~A -> A -> False.
Proof.
  intro_implicacao.
  intro_implicacao.
Admitted.
```

O resultado é: 

```coq
1 subgoal
H : ~ A -> A
H0 : ~ A
H1 : A
______________________________________(1/1)
False
```

Veja que agora possuimos duas hipóteses "contraditórias", $$H0$$ contendo o valor $$¬A$$ e $$H1$$ contendo o valor $$A$$. Neste caso, utilizamos o comando de eliminação da negação entre estas duas hipóteses, e portanto nos retornando o valor falso. Veja o exemplo:

```coq
Lemma quar_teste(H: ~A -> A) : ~A -> A -> False.
Proof.
  intro_implicacao.
  intro_implicacao.
  elim_negacao H0 H1.
Admitted.
```

E o resultado:

```coq
1 subgoal
H : ~ A -> A
H0 : ~ A
H1 : A
H2 : False
______________________________________(1/1)
False
```

A partir deste ponto, basta utilizar a identidade na hipótese $$H2$$ para finalizar a prova.

Veja um outro exemplo utilizando os comandos para eliminação e introdução da negação. Seja:

$$\dfrac{A \implies ¬A}{¬A}$$

Veja que agora a negação está tanto na conclusão como nas hipóteses da nossa prova. Para começar a nossa prova, primeiro vamos utilizar o comando de introdução da negação na conclusão da nossa prova. Daí:

```coq
Lemma qui_teste(H: A -> ~A) : ~A.
Proof.
  intro_negacao.
Admitted.
```

È o resultado:

```coq
1 subgoal
H : A -> ~ A
H0 : A
______________________________________(1/1)
False
```

Agora, como temos as hipóteses $$H0$$ e $$H$$ contendo os valores $$A$$ e $$A \implies ¬A$$, podemos utilizar o comando de eliminação da implicação para estas duas hipóteses. Então:

```coq
Lemma qui_teste(H: A -> ~A) : ~A.
Proof.
  intro_negacao.
  elim_implicacao H H0.
Admitted.
```

O que resulta em:

```coq
1 subgoal
H : A -> ~ A
H0 : A
H1 : ~ A
______________________________________(1/1)
False
```

Novamente, neste ponto, possuímos duas hipóteses contraditórias $$A$$ e $$¬A$$, então utiliza-se o comando de eliminação da negação entre as hipóteses $$H0$$ e $$H1$$. Assim sendo:

```coq
Lemma qui_teste(H: A -> ~A) : ~A.
Proof.
  intro_negacao.
  elim_implicacao H H0.
  elim_negacao H1 H0.
Admitted.
```

Que gera o resultado:

```coq
1 subgoal
H : A -> ~ A
H0 : A
H1 : ~ A
H2 : False
______________________________________(1/1)
False
```

Para terminar a prova bastar utilizar o comando de identidade para a hipótese $$H2$$ e prova está completa:

```coq
Lemma qui_teste(H: A -> ~A) : ~A.
Proof.
  intro_negacao.
  elim_implicacao H H0.
  elim_negacao H1 H0.
  id H2.
Admitted.
```

```coq
No more subgoals.
```