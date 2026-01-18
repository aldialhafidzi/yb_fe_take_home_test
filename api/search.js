export default async function handler(req, res) {
  const { q, max } = req.query;

  if (!q) {
    return res.status(400).json({ error: "Query is required" });
  }

  try {
    const response = await fetch(
      `https://gnews.io/api/v4/search?q=${encodeURIComponent(q)}&max=${max}lang=en&apikey=${process.env.GNEWS_API_KEY}`,
    );

    const data = await response.json();
    res.status(200).json(data);
  } catch (e) {
    res.status(500).json({ error: "Failed to fetch GNews" });
  }
}
