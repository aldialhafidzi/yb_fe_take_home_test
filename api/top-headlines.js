export default async function handler(req, res) {
  const { category } = req.query;

  if (!category) {
    return res.status(400).json({ error: "Category is required" });
  }

  try {
    const response = await fetch(
      `https://gnews.io/api/v4/top-headlines?category=${category}&max=5&lang=en&apikey=${process.env.GNEWS_API_KEY}`,
    );

    const data = await response.json();
    res.status(200).json(data);
  } catch (e) {
    res.status(500).json({ error: "Failed to fetch GNews" });
  }
}
