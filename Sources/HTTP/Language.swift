/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import Stream

public enum Language {
    case af
    case afZA
    case ar
    case arAE
    case arBH
    case arDZ
    case arEG
    case arIQ
    case arJO
    case arKW
    case arLB
    case arLY
    case arMA
    case arOM
    case arQA
    case arSA
    case arSY
    case arTN
    case arYE
    case az
    case azAZ
    case be
    case beBY
    case bg
    case bgBG
    case bsBA
    case ca
    case caES
    case cs
    case csCZ
    case cy
    case cyGB
    case da
    case daDK
    case de
    case deAT
    case deCH
    case deDE
    case deLI
    case deLU
    case dv
    case dvMV
    case el
    case elGR
    case en
    case enAU
    case enBZ
    case enCA
    case enCB
    case enGB
    case enIE
    case enJM
    case enNZ
    case enPH
    case enTT
    case enUS
    case enZA
    case enZW
    case eo
    case es
    case esAR
    case esBO
    case esCL
    case esCO
    case esCR
    case esDO
    case esEC
    case esES
    case esGT
    case esHN
    case esMX
    case esNI
    case esPA
    case esPE
    case esPR
    case esPY
    case esSV
    case esUY
    case esVE
    case et
    case etEE
    case eu
    case euES
    case fa
    case faIR
    case fi
    case fiFI
    case fo
    case foFO
    case fr
    case frBE
    case frCA
    case frCH
    case frFR
    case frLU
    case frMC
    case gl
    case glES
    case gu
    case guIN
    case he
    case heIL
    case hi
    case hiIN
    case hr
    case hrBA
    case hrHR
    case hu
    case huHU
    case hy
    case hyAM
    case id
    case idID
    case `is`
    case isIS
    case it
    case itCH
    case itIT
    case ja
    case jaJP
    case ka
    case kaGE
    case kk
    case kkKZ
    case kn
    case knIN
    case ko
    case koKR
    case kok
    case kokIN
    case ky
    case kyKG
    case lt
    case ltLT
    case lv
    case lvLV
    case mi
    case miNZ
    case mk
    case mkMK
    case mn
    case mnMN
    case mr
    case mrIN
    case ms
    case msBN
    case msMY
    case mt
    case mtMT
    case nb
    case nbNO
    case nl
    case nlBE
    case nlNL
    case nnNO
    case ns
    case nsZA
    case pa
    case paIN
    case pl
    case plPL
    case ps
    case psAR
    case pt
    case ptBR
    case ptPT
    case qu
    case quBO
    case quEC
    case quPE
    case ro
    case roRO
    case ru
    case ruRU
    case sa
    case saIN
    case se
    case seFI
    case seNO
    case seSE
    case sk
    case skSK
    case sl
    case slSI
    case sq
    case sqAL
    case srBA
    case srSP
    case sv
    case svFI
    case svSE
    case sw
    case swKE
    case syr
    case syrSY
    case ta
    case taIN
    case te
    case teIN
    case th
    case thTH
    case tl
    case tlPH
    case tn
    case tnZA
    case tr
    case trTR
    case tt
    case ttRU
    case ts
    case uk
    case ukUA
    case ur
    case urPK
    case uz
    case uzUZ
    case vi
    case viVN
    case xh
    case xhZA
    case zh
    case zhCN
    case zhHK
    case zhMO
    case zhSG
    case zhTW
    case zu
    case zuZA
    case any
    case custom(String)
}

extension Language {
    private struct Bytes {
        static let af    = ASCII("af")     // Afrikaans
        static let afZA  = ASCII("af-ZA")  // Afrikaans (South Africa)
        static let ar    = ASCII("ar")     // Arabic
        static let arAE  = ASCII("ar-AE")  // Arabic (U.A.E.)
        static let arBH  = ASCII("ar-BH")  // Arabic (Bahrain)
        static let arDZ  = ASCII("ar-DZ")  // Arabic (Algeria)
        static let arEG  = ASCII("ar-EG")  // Arabic (Egypt)
        static let arIQ  = ASCII("ar-IQ")  // Arabic (Iraq)
        static let arJO  = ASCII("ar-JO")  // Arabic (Jordan)
        static let arKW  = ASCII("ar-KW")  // Arabic (Kuwait)
        static let arLB  = ASCII("ar-LB")  // Arabic (Lebanon)
        static let arLY  = ASCII("ar-LY")  // Arabic (Libya)
        static let arMA  = ASCII("ar-MA")  // Arabic (Morocco)
        static let arOM  = ASCII("ar-OM")  // Arabic (Oman)
        static let arQA  = ASCII("ar-QA")  // Arabic (Qatar)
        static let arSA  = ASCII("ar-SA")  // Arabic (Saudi Arabia)
        static let arSY  = ASCII("ar-SY")  // Arabic (Syria)
        static let arTN  = ASCII("ar-TN")  // Arabic (Tunisia)
        static let arYE  = ASCII("ar-YE")  // Arabic (Yemen)
        static let az    = ASCII("az")     // Azeri (Latin)
        static let azAZ  = ASCII("az-AZ")  // Azeri (Azerbaijan)
        static let be    = ASCII("be")     // Belarusian
        static let beBY  = ASCII("be-BY")  // Belarusian (Belarus)
        static let bg    = ASCII("bg")     // Bulgarian
        static let bgBG  = ASCII("bg-BG")  // Bulgarian (Bulgaria)
        static let bsBA  = ASCII("bs-BA")  // Bosnian (Bosnia and Herzegovina)
        static let ca    = ASCII("ca")     // Catalan
        static let caES  = ASCII("ca-ES")  // Catalan (Spain)
        static let cs    = ASCII("cs")     // Czech
        static let csCZ  = ASCII("cs-CZ")  // Czech (Czech Republic)
        static let cy    = ASCII("cy")     // Welsh
        static let cyGB  = ASCII("cy-GB")  // Welsh (United Kingdom)
        static let da    = ASCII("da")     // Danish
        static let daDK  = ASCII("da-DK")  // Danish (Denmark)
        static let de    = ASCII("de")     // German
        static let deAT  = ASCII("de-AT")  // German (Austria)
        static let deCH  = ASCII("de-CH")  // German (Switzerland)
        static let deDE  = ASCII("de-DE")  // German (Germany)
        static let deLI  = ASCII("de-LI")  // German (Liechtenstein)
        static let deLU  = ASCII("de-LU")  // German (Luxembourg)
        static let dv    = ASCII("dv")     // Divehi
        static let dvMV  = ASCII("dv-MV")  // Divehi (Maldives)
        static let el    = ASCII("el")     // Greek
        static let elGR  = ASCII("el-GR")  // Greek (Greece)
        static let en    = ASCII("en")     // English
        static let enAU  = ASCII("en-AU")  // English (Australia)
        static let enBZ  = ASCII("en-BZ")  // English (Belize)
        static let enCA  = ASCII("en-CA")  // English (Canada)
        static let enCB  = ASCII("en-CB")  // English (Caribbean)
        static let enGB  = ASCII("en-GB")  // English (United Kingdom)
        static let enIE  = ASCII("en-IE")  // English (Ireland)
        static let enJM  = ASCII("en-JM")  // English (Jamaica)
        static let enNZ  = ASCII("en-NZ")  // English (New Zealand)
        static let enPH  = ASCII("en-PH")  // English (Republic of the Philippines)
        static let enTT  = ASCII("en-TT")  // English (Trinidad and Tobago)
        static let enUS  = ASCII("en-US")  // English (United States)
        static let enZA  = ASCII("en-ZA")  // English (South Africa)
        static let enZW  = ASCII("en-ZW")  // English (Zimbabwe)
        static let eo    = ASCII("eo")     // Esperanto
        static let es    = ASCII("es")     // Spanish
        static let esAR  = ASCII("es-AR")  // Spanish (Argentina)
        static let esBO  = ASCII("es-BO")  // Spanish (Bolivia)
        static let esCL  = ASCII("es-CL")  // Spanish (Chile)
        static let esCO  = ASCII("es-CO")  // Spanish (Colombia)
        static let esCR  = ASCII("es-CR")  // Spanish (Costa Rica)
        static let esDO  = ASCII("es-DO")  // Spanish (Dominican Republic)
        static let esEC  = ASCII("es-EC")  // Spanish (Ecuador)
        static let esES  = ASCII("es-ES")  // Spanish (Castilian, Spain)
        static let esGT  = ASCII("es-GT")  // Spanish (Guatemala)
        static let esHN  = ASCII("es-HN")  // Spanish (Honduras)
        static let esMX  = ASCII("es-MX")  // Spanish (Mexico)
        static let esNI  = ASCII("es-NI")  // Spanish (Nicaragua)
        static let esPA  = ASCII("es-PA")  // Spanish (Panama)
        static let esPE  = ASCII("es-PE")  // Spanish (Peru)
        static let esPR  = ASCII("es-PR")  // Spanish (Puerto Rico)
        static let esPY  = ASCII("es-PY")  // Spanish (Paraguay)
        static let esSV  = ASCII("es-SV")  // Spanish (El Salvador)
        static let esUY  = ASCII("es-UY")  // Spanish (Uruguay)
        static let esVE  = ASCII("es-VE")  // Spanish (Venezuela)
        static let et    = ASCII("et")     // Estonian
        static let etEE  = ASCII("et-EE")  // Estonian (Estonia)
        static let eu    = ASCII("eu")     // Basque
        static let euES  = ASCII("eu-ES")  // Basque (Spain)
        static let fa    = ASCII("fa")     // Farsi
        static let faIR  = ASCII("fa-IR")  // Farsi (Iran)
        static let fi    = ASCII("fi")     // Finnish
        static let fiFI  = ASCII("fi-FI")  // Finnish (Finland)
        static let fo    = ASCII("fo")     // Faroese
        static let foFO  = ASCII("fo-FO")  // Faroese (Faroe Islands)
        static let fr    = ASCII("fr")     // French
        static let frBE  = ASCII("fr-BE")  // French (Belgium)
        static let frCA  = ASCII("fr-CA")  // French (Canada)
        static let frCH  = ASCII("fr-CH")  // French (Switzerland)
        static let frFR  = ASCII("fr-FR")  // French (France)
        static let frLU  = ASCII("fr-LU")  // French (Luxembourg)
        static let frMC  = ASCII("fr-MC")  // French (Principality of Monaco)
        static let gl    = ASCII("gl")     // Galician
        static let glES  = ASCII("gl-ES")  // Galician (Spain)
        static let gu    = ASCII("gu")     // Gujarati
        static let guIN  = ASCII("gu-IN")  // Gujarati (India)
        static let he    = ASCII("he")     // Hebrew
        static let heIL  = ASCII("he-IL")  // Hebrew (Israel)
        static let hi    = ASCII("hi")     // Hindi
        static let hiIN  = ASCII("hi-IN")  // Hindi (India)
        static let hr    = ASCII("hr")     // Croatian
        static let hrBA  = ASCII("hr-BA")  // Croatian (Bosnia and Herzegovina)
        static let hrHR  = ASCII("hr-HR")  // Croatian (Croatia)
        static let hu    = ASCII("hu")     // Hungarian
        static let huHU  = ASCII("hu-HU")  // Hungarian (Hungary)
        static let hy    = ASCII("hy")     // Armenian
        static let hyAM  = ASCII("hy-AM")  // Armenian (Armenia)
        static let id    = ASCII("id")     // Indonesian
        static let idID  = ASCII("id-ID")  // Indonesian (Indonesia)
        static let `is`  = ASCII("is")     // Icelandic
        static let isIS  = ASCII("is-IS")  // Icelandic (Iceland)
        static let it    = ASCII("it")     // Italian
        static let itCH  = ASCII("it-CH")  // Italian (Switzerland)
        static let itIT  = ASCII("it-IT")  // Italian (Italy)
        static let ja    = ASCII("ja")     // Japanese
        static let jaJP  = ASCII("ja-JP")  // Japanese (Japan)
        static let ka    = ASCII("ka")     // Georgian
        static let kaGE  = ASCII("ka-GE")  // Georgian (Georgia)
        static let kk    = ASCII("kk")     // Kazakh
        static let kkKZ  = ASCII("kk-KZ")  // Kazakh (Kazakhstan)
        static let kn    = ASCII("kn")     // Kannada
        static let knIN  = ASCII("kn-IN")  // Kannada (India)
        static let ko    = ASCII("ko")     // Korean
        static let koKR  = ASCII("ko-KR")  // Korean (Korea)
        static let kok   = ASCII("kok")    // Konkani
        static let kokIN = ASCII("kok-IN") // Konkani (India)
        static let ky    = ASCII("ky")     // Kyrgyz
        static let kyKG  = ASCII("ky-KG")  // Kyrgyz (Kyrgyzstan)
        static let lt    = ASCII("lt")     // Lithuanian
        static let ltLT  = ASCII("lt-LT")  // Lithuanian (Lithuania)
        static let lv    = ASCII("lv")     // Latvian
        static let lvLV  = ASCII("lv-LV")  // Latvian (Latvia)
        static let mi    = ASCII("mi")     // Maori
        static let miNZ  = ASCII("mi-NZ")  // Maori (New Zealand)
        static let mk    = ASCII("mk")     // FYRO Macedonian
        static let mkMK  = ASCII("mk-MK")  // FYRO Macedonian (Former Yugoslav Republic of Macedonia)
        static let mn    = ASCII("mn")     // Mongolian
        static let mnMN  = ASCII("mn-MN")  // Mongolian (Mongolia)
        static let mr    = ASCII("mr")     // Marathi
        static let mrIN  = ASCII("mr-IN")  // Marathi (India)
        static let ms    = ASCII("ms")     // Malay
        static let msBN  = ASCII("ms-BN")  // Malay (Brunei Darussalam)
        static let msMY  = ASCII("ms-MY")  // Malay (Malaysia)
        static let mt    = ASCII("mt")     // Maltese
        static let mtMT  = ASCII("mt-MT")  // Maltese (Malta)
        static let nb    = ASCII("nb")     // Norwegian (Bokm?l)
        static let nbNO  = ASCII("nb-NO")  // Norwegian (Bokm?l) (Norway)
        static let nl    = ASCII("nl")     // Dutch
        static let nlBE  = ASCII("nl-BE")  // Dutch (Belgium)
        static let nlNL  = ASCII("nl-NL")  // Dutch (Netherlands)
        static let nnNO  = ASCII("nn-NO")  // Norwegian (Nynorsk) (Norway)
        static let ns    = ASCII("ns")     // Northern Sotho
        static let nsZA  = ASCII("ns-ZA")  // Northern Sotho (South Africa)
        static let pa    = ASCII("pa")     // Punjabi
        static let paIN  = ASCII("pa-IN")  // Punjabi (India)
        static let pl    = ASCII("pl")     // Polish
        static let plPL  = ASCII("pl-PL")  // Polish (Poland)
        static let ps    = ASCII("ps")     // Pashto
        static let psAR  = ASCII("ps-AR")  // Pashto (Afghanistan)
        static let pt    = ASCII("pt")     // Portuguese
        static let ptBR  = ASCII("pt-BR")  // Portuguese (Brazil)
        static let ptPT  = ASCII("pt-PT")  // Portuguese (Portugal)
        static let qu    = ASCII("qu")     // Quechua
        static let quBO  = ASCII("qu-BO")  // Quechua (Bolivia)
        static let quEC  = ASCII("qu-EC")  // Quechua (Ecuador)
        static let quPE  = ASCII("qu-PE")  // Quechua (Peru)
        static let ro    = ASCII("ro")     // Romanian
        static let roRO  = ASCII("ro-RO")  // Romanian (Romania)
        static let ru    = ASCII("ru")     // Russian
        static let ruRU  = ASCII("ru-RU")  // Russian (Russia)
        static let sa    = ASCII("sa")     // Sanskrit
        static let saIN  = ASCII("sa-IN")  // Sanskrit (India)
        static let se    = ASCII("se")     // Sami (Northern)
        static let seFI  = ASCII("se-FI")  // Sami (Finland)
        static let seNO  = ASCII("se-NO")  // Sami (Norway)
        static let seSE  = ASCII("se-SE")  // Sami (Sweden)
        static let sk    = ASCII("sk")     // Slovak
        static let skSK  = ASCII("sk-SK")  // Slovak (Slovakia)
        static let sl    = ASCII("sl")     // Slovenian
        static let slSI  = ASCII("sl-SI")  // Slovenian (Slovenia)
        static let sq    = ASCII("sq")     // Albanian
        static let sqAL  = ASCII("sq-AL")  // Albanian (Albania)
        static let srBA  = ASCII("sr-BA")  // Serbian (Bosnia and Herzegovina)
        static let srSP  = ASCII("sr-SP")  // Serbian (Serbia and Montenegro)
        static let sv    = ASCII("sv")     // Swedish
        static let svFI  = ASCII("sv-FI")  // Swedish (Finland)
        static let svSE  = ASCII("sv-SE")  // Swedish (Sweden)
        static let sw    = ASCII("sw")     // Swahili
        static let swKE  = ASCII("sw-KE")  // Swahili (Kenya)
        static let syr   = ASCII("syr")    // Syriac
        static let syrSY = ASCII("syr-SY") // Syriac (Syria)
        static let ta    = ASCII("ta")     // Tamil
        static let taIN  = ASCII("ta-IN")  // Tamil (India)
        static let te    = ASCII("te")     // Telugu
        static let teIN  = ASCII("te-IN")  // Telugu (India)
        static let th    = ASCII("th")     // Thai
        static let thTH  = ASCII("th-TH")  // Thai (Thailand)
        static let tl    = ASCII("tl")     // Tagalog
        static let tlPH  = ASCII("tl-PH")  // Tagalog (Philippines)
        static let tn    = ASCII("tn")     // Tswana
        static let tnZA  = ASCII("tn-ZA")  // Tswana (South Africa)
        static let tr    = ASCII("tr")     // Turkish
        static let trTR  = ASCII("tr-TR")  // Turkish (Turkey)
        static let tt    = ASCII("tt")     // Tatar
        static let ttRU  = ASCII("tt-RU")  // Tatar (Russia)
        static let ts    = ASCII("ts")     // Tsonga
        static let uk    = ASCII("uk")     // Ukrainian
        static let ukUA  = ASCII("uk-UA")  // Ukrainian (Ukraine)
        static let ur    = ASCII("ur")     // Urdu
        static let urPK  = ASCII("ur-PK")  // Urdu (Islamic Republic of Pakistan)
        static let uz    = ASCII("uz")     // Uzbek (Latin)
        static let uzUZ  = ASCII("uz-UZ")  // Uzbek (Uzbekistan)
        static let vi    = ASCII("vi")     // Vietnamese
        static let viVN  = ASCII("vi-VN")  // Vietnamese (Viet Nam)
        static let xh    = ASCII("xh")     // Xhosa
        static let xhZA  = ASCII("xh-ZA")  // Xhosa (South Africa)
        static let zh    = ASCII("zh")     // Chinese
        static let zhCN  = ASCII("zh-CN")  // Chinese (S)
        static let zhHK  = ASCII("zh-HK")  // Chinese (Hong Kong)
        static let zhMO  = ASCII("zh-MO")  // Chinese (Macau)
        static let zhSG  = ASCII("zh-SG")  // Chinese (Singapore)
        static let zhTW  = ASCII("zh-TW")  // Chinese (T)
        static let zu    = ASCII("zu")     // Zulu
        static let zuZA  = ASCII("zu-ZA")  // Zulu (South Africa)

        static let any   = ASCII("*")
    }

    init<T: InputStream>(from stream: BufferedInputStream<T>) throws {
        let bytes = try stream.read(allowedBytes: .token)
        switch bytes.lowercasedHashValue {
        case Bytes.af.lowercasedHashValue:    self = .af
        case Bytes.afZA.lowercasedHashValue:  self = .afZA
        case Bytes.ar.lowercasedHashValue:    self = .ar
        case Bytes.arAE.lowercasedHashValue:  self = .arAE
        case Bytes.arBH.lowercasedHashValue:  self = .arBH
        case Bytes.arDZ.lowercasedHashValue:  self = .arDZ
        case Bytes.arEG.lowercasedHashValue:  self = .arEG
        case Bytes.arIQ.lowercasedHashValue:  self = .arIQ
        case Bytes.arJO.lowercasedHashValue:  self = .arJO
        case Bytes.arKW.lowercasedHashValue:  self = .arKW
        case Bytes.arLB.lowercasedHashValue:  self = .arLB
        case Bytes.arLY.lowercasedHashValue:  self = .arLY
        case Bytes.arMA.lowercasedHashValue:  self = .arMA
        case Bytes.arOM.lowercasedHashValue:  self = .arOM
        case Bytes.arQA.lowercasedHashValue:  self = .arQA
        case Bytes.arSA.lowercasedHashValue:  self = .arSA
        case Bytes.arSY.lowercasedHashValue:  self = .arSY
        case Bytes.arTN.lowercasedHashValue:  self = .arTN
        case Bytes.arYE.lowercasedHashValue:  self = .arYE
        case Bytes.az.lowercasedHashValue:    self = .az
        case Bytes.azAZ.lowercasedHashValue:  self = .azAZ
        case Bytes.be.lowercasedHashValue:    self = .be
        case Bytes.beBY.lowercasedHashValue:  self = .beBY
        case Bytes.bg.lowercasedHashValue:    self = .bg
        case Bytes.bgBG.lowercasedHashValue:  self = .bgBG
        case Bytes.bsBA.lowercasedHashValue:  self = .bsBA
        case Bytes.ca.lowercasedHashValue:    self = .ca
        case Bytes.caES.lowercasedHashValue:  self = .caES
        case Bytes.cs.lowercasedHashValue:    self = .cs
        case Bytes.csCZ.lowercasedHashValue:  self = .csCZ
        case Bytes.cy.lowercasedHashValue:    self = .cy
        case Bytes.cyGB.lowercasedHashValue:  self = .cyGB
        case Bytes.da.lowercasedHashValue:    self = .da
        case Bytes.daDK.lowercasedHashValue:  self = .daDK
        case Bytes.de.lowercasedHashValue:    self = .de
        case Bytes.deAT.lowercasedHashValue:  self = .deAT
        case Bytes.deCH.lowercasedHashValue:  self = .deCH
        case Bytes.deDE.lowercasedHashValue:  self = .deDE
        case Bytes.deLI.lowercasedHashValue:  self = .deLI
        case Bytes.deLU.lowercasedHashValue:  self = .deLU
        case Bytes.dv.lowercasedHashValue:    self = .dv
        case Bytes.dvMV.lowercasedHashValue:  self = .dvMV
        case Bytes.el.lowercasedHashValue:    self = .el
        case Bytes.elGR.lowercasedHashValue:  self = .elGR
        case Bytes.en.lowercasedHashValue:    self = .en
        case Bytes.enAU.lowercasedHashValue:  self = .enAU
        case Bytes.enBZ.lowercasedHashValue:  self = .enBZ
        case Bytes.enCA.lowercasedHashValue:  self = .enCA
        case Bytes.enCB.lowercasedHashValue:  self = .enCB
        case Bytes.enGB.lowercasedHashValue:  self = .enGB
        case Bytes.enIE.lowercasedHashValue:  self = .enIE
        case Bytes.enJM.lowercasedHashValue:  self = .enJM
        case Bytes.enNZ.lowercasedHashValue:  self = .enNZ
        case Bytes.enPH.lowercasedHashValue:  self = .enPH
        case Bytes.enTT.lowercasedHashValue:  self = .enTT
        case Bytes.enUS.lowercasedHashValue:  self = .enUS
        case Bytes.enZA.lowercasedHashValue:  self = .enZA
        case Bytes.enZW.lowercasedHashValue:  self = .enZW
        case Bytes.eo.lowercasedHashValue:    self = .eo
        case Bytes.es.lowercasedHashValue:    self = .es
        case Bytes.esAR.lowercasedHashValue:  self = .esAR
        case Bytes.esBO.lowercasedHashValue:  self = .esBO
        case Bytes.esCL.lowercasedHashValue:  self = .esCL
        case Bytes.esCO.lowercasedHashValue:  self = .esCO
        case Bytes.esCR.lowercasedHashValue:  self = .esCR
        case Bytes.esDO.lowercasedHashValue:  self = .esDO
        case Bytes.esEC.lowercasedHashValue:  self = .esEC
        case Bytes.esES.lowercasedHashValue:  self = .esES
        case Bytes.esGT.lowercasedHashValue:  self = .esGT
        case Bytes.esHN.lowercasedHashValue:  self = .esHN
        case Bytes.esMX.lowercasedHashValue:  self = .esMX
        case Bytes.esNI.lowercasedHashValue:  self = .esNI
        case Bytes.esPA.lowercasedHashValue:  self = .esPA
        case Bytes.esPE.lowercasedHashValue:  self = .esPE
        case Bytes.esPR.lowercasedHashValue:  self = .esPR
        case Bytes.esPY.lowercasedHashValue:  self = .esPY
        case Bytes.esSV.lowercasedHashValue:  self = .esSV
        case Bytes.esUY.lowercasedHashValue:  self = .esUY
        case Bytes.esVE.lowercasedHashValue:  self = .esVE
        case Bytes.et.lowercasedHashValue:    self = .et
        case Bytes.etEE.lowercasedHashValue:  self = .etEE
        case Bytes.eu.lowercasedHashValue:    self = .eu
        case Bytes.euES.lowercasedHashValue:  self = .euES
        case Bytes.fa.lowercasedHashValue:    self = .fa
        case Bytes.faIR.lowercasedHashValue:  self = .faIR
        case Bytes.fi.lowercasedHashValue:    self = .fi
        case Bytes.fiFI.lowercasedHashValue:  self = .fiFI
        case Bytes.fo.lowercasedHashValue:    self = .fo
        case Bytes.foFO.lowercasedHashValue:  self = .foFO
        case Bytes.fr.lowercasedHashValue:    self = .fr
        case Bytes.frBE.lowercasedHashValue:  self = .frBE
        case Bytes.frCA.lowercasedHashValue:  self = .frCA
        case Bytes.frCH.lowercasedHashValue:  self = .frCH
        case Bytes.frFR.lowercasedHashValue:  self = .frFR
        case Bytes.frLU.lowercasedHashValue:  self = .frLU
        case Bytes.frMC.lowercasedHashValue:  self = .frMC
        case Bytes.gl.lowercasedHashValue:    self = .gl
        case Bytes.glES.lowercasedHashValue:  self = .glES
        case Bytes.gu.lowercasedHashValue:    self = .gu
        case Bytes.guIN.lowercasedHashValue:  self = .guIN
        case Bytes.he.lowercasedHashValue:    self = .he
        case Bytes.heIL.lowercasedHashValue:  self = .heIL
        case Bytes.hi.lowercasedHashValue:    self = .hi
        case Bytes.hiIN.lowercasedHashValue:  self = .hiIN
        case Bytes.hr.lowercasedHashValue:    self = .hr
        case Bytes.hrBA.lowercasedHashValue:  self = .hrBA
        case Bytes.hrHR.lowercasedHashValue:  self = .hrHR
        case Bytes.hu.lowercasedHashValue:    self = .hu
        case Bytes.huHU.lowercasedHashValue:  self = .huHU
        case Bytes.hy.lowercasedHashValue:    self = .hy
        case Bytes.hyAM.lowercasedHashValue:  self = .hyAM
        case Bytes.id.lowercasedHashValue:    self = .id
        case Bytes.idID.lowercasedHashValue:  self = .idID
        case Bytes.is.lowercasedHashValue:    self = .is
        case Bytes.isIS.lowercasedHashValue:  self = .isIS
        case Bytes.it.lowercasedHashValue:    self = .it
        case Bytes.itCH.lowercasedHashValue:  self = .itCH
        case Bytes.itIT.lowercasedHashValue:  self = .itIT
        case Bytes.ja.lowercasedHashValue:    self = .ja
        case Bytes.jaJP.lowercasedHashValue:  self = .jaJP
        case Bytes.ka.lowercasedHashValue:    self = .ka
        case Bytes.kaGE.lowercasedHashValue:  self = .kaGE
        case Bytes.kk.lowercasedHashValue:    self = .kk
        case Bytes.kkKZ.lowercasedHashValue:  self = .kkKZ
        case Bytes.kn.lowercasedHashValue:    self = .kn
        case Bytes.knIN.lowercasedHashValue:  self = .knIN
        case Bytes.ko.lowercasedHashValue:    self = .ko
        case Bytes.koKR.lowercasedHashValue:  self = .koKR
        case Bytes.kok.lowercasedHashValue:   self = .kok
        case Bytes.kokIN.lowercasedHashValue: self = .kokIN
        case Bytes.ky.lowercasedHashValue:    self = .ky
        case Bytes.kyKG.lowercasedHashValue:  self = .kyKG
        case Bytes.lt.lowercasedHashValue:    self = .lt
        case Bytes.ltLT.lowercasedHashValue:  self = .ltLT
        case Bytes.lv.lowercasedHashValue:    self = .lv
        case Bytes.lvLV.lowercasedHashValue:  self = .lvLV
        case Bytes.mi.lowercasedHashValue:    self = .mi
        case Bytes.miNZ.lowercasedHashValue:  self = .miNZ
        case Bytes.mk.lowercasedHashValue:    self = .mk
        case Bytes.mkMK.lowercasedHashValue:  self = .mkMK
        case Bytes.mn.lowercasedHashValue:    self = .mn
        case Bytes.mnMN.lowercasedHashValue:  self = .mnMN
        case Bytes.mr.lowercasedHashValue:    self = .mr
        case Bytes.mrIN.lowercasedHashValue:  self = .mrIN
        case Bytes.ms.lowercasedHashValue:    self = .ms
        case Bytes.msBN.lowercasedHashValue:  self = .msBN
        case Bytes.msMY.lowercasedHashValue:  self = .msMY
        case Bytes.mt.lowercasedHashValue:    self = .mt
        case Bytes.mtMT.lowercasedHashValue:  self = .mtMT
        case Bytes.nb.lowercasedHashValue:    self = .nb
        case Bytes.nbNO.lowercasedHashValue:  self = .nbNO
        case Bytes.nl.lowercasedHashValue:    self = .nl
        case Bytes.nlBE.lowercasedHashValue:  self = .nlBE
        case Bytes.nlNL.lowercasedHashValue:  self = .nlNL
        case Bytes.nnNO.lowercasedHashValue:  self = .nnNO
        case Bytes.ns.lowercasedHashValue:    self = .ns
        case Bytes.nsZA.lowercasedHashValue:  self = .nsZA
        case Bytes.pa.lowercasedHashValue:    self = .pa
        case Bytes.paIN.lowercasedHashValue:  self = .paIN
        case Bytes.pl.lowercasedHashValue:    self = .pl
        case Bytes.plPL.lowercasedHashValue:  self = .plPL
        case Bytes.ps.lowercasedHashValue:    self = .ps
        case Bytes.psAR.lowercasedHashValue:  self = .psAR
        case Bytes.pt.lowercasedHashValue:    self = .pt
        case Bytes.ptBR.lowercasedHashValue:  self = .ptBR
        case Bytes.ptPT.lowercasedHashValue:  self = .ptPT
        case Bytes.qu.lowercasedHashValue:    self = .qu
        case Bytes.quBO.lowercasedHashValue:  self = .quBO
        case Bytes.quEC.lowercasedHashValue:  self = .quEC
        case Bytes.quPE.lowercasedHashValue:  self = .quPE
        case Bytes.ro.lowercasedHashValue:    self = .ro
        case Bytes.roRO.lowercasedHashValue:  self = .roRO
        case Bytes.ru.lowercasedHashValue:    self = .ru
        case Bytes.ruRU.lowercasedHashValue:  self = .ruRU
        case Bytes.sa.lowercasedHashValue:    self = .sa
        case Bytes.saIN.lowercasedHashValue:  self = .saIN
        case Bytes.se.lowercasedHashValue:    self = .se
        case Bytes.seFI.lowercasedHashValue:  self = .seFI
        case Bytes.seNO.lowercasedHashValue:  self = .seNO
        case Bytes.seSE.lowercasedHashValue:  self = .seSE
        case Bytes.sk.lowercasedHashValue:    self = .sk
        case Bytes.skSK.lowercasedHashValue:  self = .skSK
        case Bytes.sl.lowercasedHashValue:    self = .sl
        case Bytes.slSI.lowercasedHashValue:  self = .slSI
        case Bytes.sq.lowercasedHashValue:    self = .sq
        case Bytes.sqAL.lowercasedHashValue:  self = .sqAL
        case Bytes.srBA.lowercasedHashValue:  self = .srBA
        case Bytes.srSP.lowercasedHashValue:  self = .srSP
        case Bytes.sv.lowercasedHashValue:    self = .sv
        case Bytes.svFI.lowercasedHashValue:  self = .svFI
        case Bytes.svSE.lowercasedHashValue:  self = .svSE
        case Bytes.sw.lowercasedHashValue:    self = .sw
        case Bytes.swKE.lowercasedHashValue:  self = .swKE
        case Bytes.syr.lowercasedHashValue:   self = .syr
        case Bytes.syrSY.lowercasedHashValue: self = .syrSY
        case Bytes.ta.lowercasedHashValue:    self = .ta
        case Bytes.taIN.lowercasedHashValue:  self = .taIN
        case Bytes.te.lowercasedHashValue:    self = .te
        case Bytes.teIN.lowercasedHashValue:  self = .teIN
        case Bytes.th.lowercasedHashValue:    self = .th
        case Bytes.thTH.lowercasedHashValue:  self = .thTH
        case Bytes.tl.lowercasedHashValue:    self = .tl
        case Bytes.tlPH.lowercasedHashValue:  self = .tlPH
        case Bytes.tn.lowercasedHashValue:    self = .tn
        case Bytes.tnZA.lowercasedHashValue:  self = .tnZA
        case Bytes.tr.lowercasedHashValue:    self = .tr
        case Bytes.trTR.lowercasedHashValue:  self = .trTR
        case Bytes.tt.lowercasedHashValue:    self = .tt
        case Bytes.ttRU.lowercasedHashValue:  self = .ttRU
        case Bytes.ts.lowercasedHashValue:    self = .ts
        case Bytes.uk.lowercasedHashValue:    self = .uk
        case Bytes.ukUA.lowercasedHashValue:  self = .ukUA
        case Bytes.ur.lowercasedHashValue:    self = .ur
        case Bytes.urPK.lowercasedHashValue:  self = .urPK
        case Bytes.uz.lowercasedHashValue:    self = .uz
        case Bytes.uzUZ.lowercasedHashValue:  self = .uzUZ
        case Bytes.vi.lowercasedHashValue:    self = .vi
        case Bytes.viVN.lowercasedHashValue:  self = .viVN
        case Bytes.xh.lowercasedHashValue:    self = .xh
        case Bytes.xhZA.lowercasedHashValue:  self = .xhZA
        case Bytes.zh.lowercasedHashValue:    self = .zh
        case Bytes.zhCN.lowercasedHashValue:  self = .zhCN
        case Bytes.zhHK.lowercasedHashValue:  self = .zhHK
        case Bytes.zhMO.lowercasedHashValue:  self = .zhMO
        case Bytes.zhSG.lowercasedHashValue:  self = .zhSG
        case Bytes.zhTW.lowercasedHashValue:  self = .zhTW
        case Bytes.zu.lowercasedHashValue:    self = .zu
        case Bytes.zuZA.lowercasedHashValue:  self = .zuZA
        case Bytes.any.lowercasedHashValue:   self = .any
        default: self = .custom(String(decoding: bytes, as: UTF8.self))
        }
    }

    func encode<T: OutputStream>(to stream: BufferedOutputStream<T>) throws {
        let bytes: [UInt8]
        switch self {
        case .af:    bytes = Bytes.af
        case .afZA:  bytes = Bytes.afZA
        case .ar:    bytes = Bytes.ar
        case .arAE:  bytes = Bytes.arAE
        case .arBH:  bytes = Bytes.arBH
        case .arDZ:  bytes = Bytes.arDZ
        case .arEG:  bytes = Bytes.arEG
        case .arIQ:  bytes = Bytes.arIQ
        case .arJO:  bytes = Bytes.arJO
        case .arKW:  bytes = Bytes.arKW
        case .arLB:  bytes = Bytes.arLB
        case .arLY:  bytes = Bytes.arLY
        case .arMA:  bytes = Bytes.arMA
        case .arOM:  bytes = Bytes.arOM
        case .arQA:  bytes = Bytes.arQA
        case .arSA:  bytes = Bytes.arSA
        case .arSY:  bytes = Bytes.arSY
        case .arTN:  bytes = Bytes.arTN
        case .arYE:  bytes = Bytes.arYE
        case .az:    bytes = Bytes.az
        case .azAZ:  bytes = Bytes.azAZ
        case .be:    bytes = Bytes.be
        case .beBY:  bytes = Bytes.beBY
        case .bg:    bytes = Bytes.bg
        case .bgBG:  bytes = Bytes.bgBG
        case .bsBA:  bytes = Bytes.bsBA
        case .ca:    bytes = Bytes.ca
        case .caES:  bytes = Bytes.caES
        case .cs:    bytes = Bytes.cs
        case .csCZ:  bytes = Bytes.csCZ
        case .cy:    bytes = Bytes.cy
        case .cyGB:  bytes = Bytes.cyGB
        case .da:    bytes = Bytes.da
        case .daDK:  bytes = Bytes.daDK
        case .de:    bytes = Bytes.de
        case .deAT:  bytes = Bytes.deAT
        case .deCH:  bytes = Bytes.deCH
        case .deDE:  bytes = Bytes.deDE
        case .deLI:  bytes = Bytes.deLI
        case .deLU:  bytes = Bytes.deLU
        case .dv:    bytes = Bytes.dv
        case .dvMV:  bytes = Bytes.dvMV
        case .el:    bytes = Bytes.el
        case .elGR:  bytes = Bytes.elGR
        case .en:    bytes = Bytes.en
        case .enAU:  bytes = Bytes.enAU
        case .enBZ:  bytes = Bytes.enBZ
        case .enCA:  bytes = Bytes.enCA
        case .enCB:  bytes = Bytes.enCB
        case .enGB:  bytes = Bytes.enGB
        case .enIE:  bytes = Bytes.enIE
        case .enJM:  bytes = Bytes.enJM
        case .enNZ:  bytes = Bytes.enNZ
        case .enPH:  bytes = Bytes.enPH
        case .enTT:  bytes = Bytes.enTT
        case .enUS:  bytes = Bytes.enUS
        case .enZA:  bytes = Bytes.enZA
        case .enZW:  bytes = Bytes.enZW
        case .eo:    bytes = Bytes.eo
        case .es:    bytes = Bytes.es
        case .esAR:  bytes = Bytes.esAR
        case .esBO:  bytes = Bytes.esBO
        case .esCL:  bytes = Bytes.esCL
        case .esCO:  bytes = Bytes.esCO
        case .esCR:  bytes = Bytes.esCR
        case .esDO:  bytes = Bytes.esDO
        case .esEC:  bytes = Bytes.esEC
        case .esES:  bytes = Bytes.esES
        case .esGT:  bytes = Bytes.esGT
        case .esHN:  bytes = Bytes.esHN
        case .esMX:  bytes = Bytes.esMX
        case .esNI:  bytes = Bytes.esNI
        case .esPA:  bytes = Bytes.esPA
        case .esPE:  bytes = Bytes.esPE
        case .esPR:  bytes = Bytes.esPR
        case .esPY:  bytes = Bytes.esPY
        case .esSV:  bytes = Bytes.esSV
        case .esUY:  bytes = Bytes.esUY
        case .esVE:  bytes = Bytes.esVE
        case .et:    bytes = Bytes.et
        case .etEE:  bytes = Bytes.etEE
        case .eu:    bytes = Bytes.eu
        case .euES:  bytes = Bytes.euES
        case .fa:    bytes = Bytes.fa
        case .faIR:  bytes = Bytes.faIR
        case .fi:    bytes = Bytes.fi
        case .fiFI:  bytes = Bytes.fiFI
        case .fo:    bytes = Bytes.fo
        case .foFO:  bytes = Bytes.foFO
        case .fr:    bytes = Bytes.fr
        case .frBE:  bytes = Bytes.frBE
        case .frCA:  bytes = Bytes.frCA
        case .frCH:  bytes = Bytes.frCH
        case .frFR:  bytes = Bytes.frFR
        case .frLU:  bytes = Bytes.frLU
        case .frMC:  bytes = Bytes.frMC
        case .gl:    bytes = Bytes.gl
        case .glES:  bytes = Bytes.glES
        case .gu:    bytes = Bytes.gu
        case .guIN:  bytes = Bytes.guIN
        case .he:    bytes = Bytes.he
        case .heIL:  bytes = Bytes.heIL
        case .hi:    bytes = Bytes.hi
        case .hiIN:  bytes = Bytes.hiIN
        case .hr:    bytes = Bytes.hr
        case .hrBA:  bytes = Bytes.hrBA
        case .hrHR:  bytes = Bytes.hrHR
        case .hu:    bytes = Bytes.hu
        case .huHU:  bytes = Bytes.huHU
        case .hy:    bytes = Bytes.hy
        case .hyAM:  bytes = Bytes.hyAM
        case .id:    bytes = Bytes.id
        case .idID:  bytes = Bytes.idID
        case .`is`:  bytes = Bytes.is
        case .isIS:  bytes = Bytes.isIS
        case .it:    bytes = Bytes.it
        case .itCH:  bytes = Bytes.itCH
        case .itIT:  bytes = Bytes.itIT
        case .ja:    bytes = Bytes.ja
        case .jaJP:  bytes = Bytes.jaJP
        case .ka:    bytes = Bytes.ka
        case .kaGE:  bytes = Bytes.kaGE
        case .kk:    bytes = Bytes.kk
        case .kkKZ:  bytes = Bytes.kkKZ
        case .kn:    bytes = Bytes.kn
        case .knIN:  bytes = Bytes.knIN
        case .ko:    bytes = Bytes.ko
        case .koKR:  bytes = Bytes.koKR
        case .kok:   bytes = Bytes.kok
        case .kokIN: bytes = Bytes.kokIN
        case .ky:    bytes = Bytes.ky
        case .kyKG:  bytes = Bytes.kyKG
        case .lt:    bytes = Bytes.lt
        case .ltLT:  bytes = Bytes.ltLT
        case .lv:    bytes = Bytes.lv
        case .lvLV:  bytes = Bytes.lvLV
        case .mi:    bytes = Bytes.mi
        case .miNZ:  bytes = Bytes.miNZ
        case .mk:    bytes = Bytes.mk
        case .mkMK:  bytes = Bytes.mkMK
        case .mn:    bytes = Bytes.mn
        case .mnMN:  bytes = Bytes.mnMN
        case .mr:    bytes = Bytes.mr
        case .mrIN:  bytes = Bytes.mrIN
        case .ms:    bytes = Bytes.ms
        case .msBN:  bytes = Bytes.msBN
        case .msMY:  bytes = Bytes.msMY
        case .mt:    bytes = Bytes.mt
        case .mtMT:  bytes = Bytes.mtMT
        case .nb:    bytes = Bytes.nb
        case .nbNO:  bytes = Bytes.nbNO
        case .nl:    bytes = Bytes.nl
        case .nlBE:  bytes = Bytes.nlBE
        case .nlNL:  bytes = Bytes.nlNL
        case .nnNO:  bytes = Bytes.nnNO
        case .ns:    bytes = Bytes.ns
        case .nsZA:  bytes = Bytes.nsZA
        case .pa:    bytes = Bytes.pa
        case .paIN:  bytes = Bytes.paIN
        case .pl:    bytes = Bytes.pl
        case .plPL:  bytes = Bytes.plPL
        case .ps:    bytes = Bytes.ps
        case .psAR:  bytes = Bytes.psAR
        case .pt:    bytes = Bytes.pt
        case .ptBR:  bytes = Bytes.ptBR
        case .ptPT:  bytes = Bytes.ptPT
        case .qu:    bytes = Bytes.qu
        case .quBO:  bytes = Bytes.quBO
        case .quEC:  bytes = Bytes.quEC
        case .quPE:  bytes = Bytes.quPE
        case .ro:    bytes = Bytes.ro
        case .roRO:  bytes = Bytes.roRO
        case .ru:    bytes = Bytes.ru
        case .ruRU:  bytes = Bytes.ruRU
        case .sa:    bytes = Bytes.sa
        case .saIN:  bytes = Bytes.saIN
        case .se:    bytes = Bytes.se
        case .seFI:  bytes = Bytes.seFI
        case .seNO:  bytes = Bytes.seNO
        case .seSE:  bytes = Bytes.seSE
        case .sk:    bytes = Bytes.sk
        case .skSK:  bytes = Bytes.skSK
        case .sl:    bytes = Bytes.sl
        case .slSI:  bytes = Bytes.slSI
        case .sq:    bytes = Bytes.sq
        case .sqAL:  bytes = Bytes.sqAL
        case .srBA:  bytes = Bytes.srBA
        case .srSP:  bytes = Bytes.srSP
        case .sv:    bytes = Bytes.sv
        case .svFI:  bytes = Bytes.svFI
        case .svSE:  bytes = Bytes.svSE
        case .sw:    bytes = Bytes.sw
        case .swKE:  bytes = Bytes.swKE
        case .syr:   bytes = Bytes.syr
        case .syrSY: bytes = Bytes.syrSY
        case .ta:    bytes = Bytes.ta
        case .taIN:  bytes = Bytes.taIN
        case .te:    bytes = Bytes.te
        case .teIN:  bytes = Bytes.teIN
        case .th:    bytes = Bytes.th
        case .thTH:  bytes = Bytes.thTH
        case .tl:    bytes = Bytes.tl
        case .tlPH:  bytes = Bytes.tlPH
        case .tn:    bytes = Bytes.tn
        case .tnZA:  bytes = Bytes.tnZA
        case .tr:    bytes = Bytes.tr
        case .trTR:  bytes = Bytes.trTR
        case .tt:    bytes = Bytes.tt
        case .ttRU:  bytes = Bytes.ttRU
        case .ts:    bytes = Bytes.ts
        case .uk:    bytes = Bytes.uk
        case .ukUA:  bytes = Bytes.ukUA
        case .ur:    bytes = Bytes.ur
        case .urPK:  bytes = Bytes.urPK
        case .uz:    bytes = Bytes.uz
        case .uzUZ:  bytes = Bytes.uzUZ
        case .vi:    bytes = Bytes.vi
        case .viVN:  bytes = Bytes.viVN
        case .xh:    bytes = Bytes.xh
        case .xhZA:  bytes = Bytes.xhZA
        case .zh:    bytes = Bytes.zh
        case .zhCN:  bytes = Bytes.zhCN
        case .zhHK:  bytes = Bytes.zhHK
        case .zhMO:  bytes = Bytes.zhMO
        case .zhSG:  bytes = Bytes.zhSG
        case .zhTW:  bytes = Bytes.zhTW
        case .zu:    bytes = Bytes.zu
        case .zuZA:  bytes = Bytes.zuZA
        case .any:   bytes = Bytes.any
        case .custom(let value): bytes = [UInt8](value)
        }
        try stream.write(bytes)
    }
}
