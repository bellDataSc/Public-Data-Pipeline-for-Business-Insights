import java.io.File

fun saveCsv(filename: String, data: List<List<String>>) {
    val file = File(filename)
    file.printWriter().use { out ->
        data.forEach { row ->
            out.println(row.joinToString(","))
        }
    }
}

fun main() {
    val headers = listOf("State", "Population")
    val rows = listOf(
        listOf("São Paulo", "46000000"),
        listOf("Minas Gerais", "21000000"),
        listOf("Rio de Janeiro", "17000000")
    )

    val allRows = listOf(headers) + rows
    saveCsv("population.csv", allRows)
    println("✅ File saved successfully.")
}
