defmodule Discuss.TopicController do
    use Discuss.Web, :controller

    alias Discuss.Topic

    def index(conn, _params) do
        # in shell: Discuss.Repo.all(Discuss.Topic)
        topics = Repo.all(Topic)
        render conn, "index.html", topics: topics
    end

    def new(conn, _params) do
        changeset = Topic.changeset(%Topic{}, %{})
        render conn, "new.html", changeset: changeset
    end

    # def create(conn, params) do
    #     IO.inspect(params)
    #     %{"topic" => topic} = params
    # end
    # simplified below

    def create(conn, %{"topic" => topic}) do
        changeset = Topic.changeset(%Topic{}, topic)

        case Repo.insert(changeset) do
            {:ok, _topic} ->
                conn
                |> put_flash(:info, "Topic Created")
                |> redirect(to: topic_path(conn, :index))
            {:error, changeset} ->
                render conn, "new.html", changeset: changeset
        end
    end

    def edit(conn, %{"id" => topic_id}) do
        topic = Repo.get(Topic, topic_id)
        changeset = Topic.changeset(topic)
        render conn, "edit.html", changeset: changeset, topic: topic
    end

    def update(conn, %{"id" => topic_id, "topic" => topic}) do
        old_topic = Repo.get(Topic, topic_id)
        changeset = Topic.changeset(old_topic, topic)
        # changeset = Repo.get(Topic, topic_id) |> Topic.changeset(topic)
        
        case Repo.update(changeset) do
            {:ok, _topic} ->
                conn
                |> put_flash(:info, "Topic Updated")
                |> redirect(to: topic_path(conn, :index))
            {:error, changeset} ->
                render conn, "edit.html", changeset: changeset, topic: old_topic
        end
    end

    def delete(conn, %{"id" => topic_id}) do
        topic = Repo.get(Topic, topic_id)
        changeset = Topic.changeset(topic)
        case Repo.delete(changeset) do
            {:ok, _changeset} ->
                conn
                |> put_flash(:info, "Topic deleted")
                |> redirect(to: topic_path(conn, :index))
            {:error, changeset} ->
                render conn, "index.html", changeset: changeset
        end
    end
end