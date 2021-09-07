USE BD_ANAC

SELECT * FROM TB_AERODROMO
SELECT * FROM TB_EMPRESA

SELECT * FROM TB_JUSTIFICATIVA
SELECT * FROM TB_TIPO_LINHA
SELECT * FROM TB_TIPO_VOO
SELECT * FROM TB_VOO
---------------------------------------------------------------------------------------
-- QUAL A DURA��O REAL M�DIA (EM MINUTOS) DOS VOOS REALIZADOS 
-- ENTRE A CIDADE DE S�O PAULO (ORIGEM) E A CIDADE DO RIO DE JANEIRO (DESTINO)?

SELECT 
	AVG(DATEDIFF(MINUTE, DT_HR_PARTIDA_REAL, DT_HR_CHEGADA_REAL)) AS [DURA��O M�DIA DOS VOOS DE SP A RJ EM MINUTOS]
FROM TB_VOO 
WHERE ID_AERODROMO_ORIGEM IN (SELECT ID FROM TB_AERODROMO WHERE NM_CIDADE = 'S�O PAULO') AND 
      ID_AERODROMO_DESTINO IN (SELECT ID FROM TB_AERODROMO WHERE NM_CIDADE = 'RIO DE JANEIRO')
---------------------------------------------------------------------------------------
-- QUAL A EMPRESA QUE POSSUI A MAIOR M�DIA DE ATRASADO NA CHEGADA?

SELECT TOP 1
	TB_EMPRESA.NM_EMPRESA AS [NOME DA EMPRESA],
	AVG(DATEDIFF(MINUTE, DT_HR_CHEGADA_PREVISTA, DT_HR_CHEGADA_REAL)) AS [M�DIA DE ATRASADO NA CHEGADA]
FROM TB_EMPRESA 
JOIN TB_VOO ON TB_VOO.ID_EMPRESA = TB_EMPRESA.ID
GROUP BY TB_EMPRESA.NM_EMPRESA
ORDER BY [M�DIA DE ATRASADO NA CHEGADA] DESC
---------------------------------------------------------------------------------------
-- QUAL O AEROPORTO (AER�DROMOS) DE ORIGEM QUE TEVE O MAIOR PERCENTUAL DE 
-- VOOS, CLASSIFICADOS COMO REGULARES, CANCELADOS (QUANTIDADE DE VOOS 
-- CANCELADOS/ QUANTIDADE TOTAL DE VOOS), CONSIDERE APENAS OS AEROPORTOS 
-- COM MAIS DE 5 MIL VOOS REGULARES.
SELECT ID_AERODROMO_ORIGEM AS [AER�DROMO],
	   COUNT(ID_AERODROMO_ORIGEM) AS [QTD V�OS CANCELADOS]
FROM TB_VOO
WHERE ID_JUSTIFICATIVA IN (
			SELECT ID FROM TB_JUSTIFICATIVA WHERE DS_JUSTIFICATIVA LIKE 'CANCELA%'
			) AND
      ID_AERODROMO_ORIGEM IN (
			SELECT ID_AERODROMO_ORIGEM FROM TB_VOO 
            GROUP BY ID_AERODROMO_ORIGEM HAVING COUNT(ID_AERODROMO_ORIGEM) > 5000
			) AND
      ID_TIPO_VOO = 0
GROUP BY ID_AERODROMO_ORIGEM
ORDER BY ID_AERODROMO_ORIGEM

------

SELECT ID_AERODROMO_ORIGEM AS [AER�DROMO],
	   COUNT(ID_AERODROMO_ORIGEM) AS [QTD V�OS]
FROM TB_VOO
WHERE ID_AERODROMO_ORIGEM IN (
			SELECT ID_AERODROMO_ORIGEM FROM TB_VOO 
            GROUP BY ID_AERODROMO_ORIGEM HAVING COUNT(ID_AERODROMO_ORIGEM) > 5000
			) AND
      ID_TIPO_VOO = 0
GROUP BY ID_AERODROMO_ORIGEM
ORDER BY ID_AERODROMO_ORIGEM

SELECT * FROM TB_AERODROMO WHERE ID = 432
---------------------------------------------------------------------------------------
-- QUAL A EMPRESA BRASILEIRA COM A MAIOR QUANTIDADE DE VOOS, QUE S� 
-- ATUOU COM VOOS COM SERVI�O DE TIPO DE LINHA MISTA (N�O TEVE VOOS COM 
-- COM SERVI�O DE TIPO DE LINHA CARGUEIRA)

SELECT
	   ID_EMPRESA AS [EMPRESA],
	   COUNT(ID_EMPRESA) AS [QTD V�OS]
FROM TB_VOO
WHERE ID_TIPO_LINHA IN (
			SELECT ID FROM TB_TIPO_LINHA WHERE DS_SERVICO_TIPO_LINHA = 'Mista'
			) AND
	  ID_EMPRESA IN (
	        SELECT ID FROM TB_EMPRESA WHERE DS_TIPO_EMPRESA = 'BRASILEIRA'
			)
GROUP BY ID_EMPRESA
ORDER BY COUNT(ID_EMPRESA) DESC

SELECT * FROM TB_VOO WHERE ID_EMPRESA = 61 AND ID_TIPO_LINHA NOT IN (SELECT ID FROM TB_TIPO_LINHA WHERE DS_SERVICO_TIPO_LINHA = 'Mista')

SELECT * FROM TB_EMPRESA WHERE ID = 61