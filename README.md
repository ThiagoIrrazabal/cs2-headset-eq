# EQ de fone para CS2 — ouvir passos melhor

Muito fone gamer barato vem com **grave exagerado**. O grave cobre a faixa onde ficam os **passos e a posição dos inimigos (2–5 kHz)**, e o som fica "abafado". Você só ouve o inimigo quando ele já está perto, e fica difícil saber quantos são.

Este pacote corrige isso com o **Equalizer APO**, um equalizador gratuito e de código aberto para Windows. Ele afeta **somente o fone**: o microfone não muda.

> O tamanho do driver (40 mm ou 50 mm) diz pouco sobre o som. O que importa é a afinação, ou seja, quais frequências o fone destaca.

## O que o preset faz

| Faixa | Ajuste | Efeito |
|---|---|---|
| Grave (< 150 Hz) | -4 dB | tira o abafado |
| 300 Hz | -2 dB | tira o som de "caixa" |
| **3 kHz** | **+4 dB** | **passos e posicionamento** |
| 7 kHz | +2 dB | detalhe e definição |
| Volume geral | -5 dB | evita distorção (compense no volume) |

Foi testado com o **Pantera Eco Light** (USB). Deve ajudar na maioria dos fones com muito grave.

## Instalação (sem Claude)

1. Baixe este repositório: botão verde **Code → Download ZIP** e extraia.
2. Abra o **PowerShell como administrador** (Iniciar → digite "PowerShell" → botão direito → *Executar como administrador*).
3. Rode, trocando pelo caminho onde você extraiu:
   ```powershell
   powershell -ExecutionPolicy Bypass -File "C:\caminho\cs2-headset-eq\skills\cs2-headset-eq\install.ps1"
   ```
4. O script baixa o Equalizer APO do site oficial (SourceForge) e confere a integridade do arquivo. Depois abre a janela **Device Selector**:
   - Na aba de reprodução (*Playback devices*), marque **somente o seu fone**.
   - **Não marque o microfone.**
   - Clique em OK.
5. **Reinicie o PC.**

Se o Equalizer APO já estiver instalado, o script só aplica o preset. O config anterior fica salvo em `config_original.txt`.

## Instalação com Claude Code (plugin)

```
/plugin marketplace add ThiagoIrrazabal/cs2-headset-eq
/plugin install cs2-headset-eq@cs2-headset-eq
```

Depois é só pedir algo como *"o som do meu fone tá abafado no CS2"*. O Claude faz o diagnóstico, pede sua permissão e roda a instalação.

## Configurações complementares (importantes)

- **CS2** → Configurações → Áudio → **Perfil de EQ: "Crisp"**
- **Windows** → botão direito no ícone de som → **Som espacial: Desativado** (o CS2 já tem áudio 3D próprio)
- Se o fone tiver **7.1 virtual** no software dele, desligue.

## Ajuste fino

Edite `C:\Program Files\EqualizerAPO\config\config.txt`. A mudança vale na hora, sem reiniciar:
- **Ainda abafado:** aumente o `3000 Hz` (até +6 dB).
- **Chiado ou cansativo:** diminua o `7000 Hz` ou o `3000 Hz`.

## Desfazer

- Voltar ao config anterior: copie `config_original.txt` por cima de `config.txt`.
- Remover tudo: Painel de Controle → Desinstalar "Equalizer APO" → reiniciar.

## Licença

MIT. O Equalizer APO é um projeto independente (GPL), baixado direto do [SourceForge oficial](https://sourceforge.net/projects/equalizerapo/).
